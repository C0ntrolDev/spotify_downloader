import 'dart:io';

import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/bitrate_editor/audio_bitrate_editor.dart';

class LowLevelMp3AudioBitrateEditorImpl implements AudioBitrateEditor {
  final Map<int, int> _possibleBitratesWithKeys = {
    32: int.parse("0001", radix: 2),
    40: int.parse("0001", radix: 2),
    48: int.parse("0010", radix: 2),
    56: int.parse("0011", radix: 2),
    64: int.parse("0100", radix: 2),
    80: int.parse("0101", radix: 2),
    96: int.parse("0110", radix: 2),
    112: int.parse("0111", radix: 2),
    128: int.parse("1001", radix: 2),
    160: int.parse("1010", radix: 2),
    192: int.parse("1011", radix: 2),
    224: int.parse("1100", radix: 2),
    256: int.parse("1101", radix: 2),
    320: int.parse("1110", radix: 2)
  };

  @override
  Future<Result<Failure, bool>> changeBitrate(String path, int bitrate) async {
    if (!path.endsWith("mp3")) {
      return const Result.notSuccessful(Failure(message: "Can't change bitrate in file that isn't .mp3"));
    }

    final file = await File(path).open(mode: FileMode.append);
    await file.setPosition(0);

    try {
      while (true) {
        final byte1 = await file.readByte();
        if (byte1 == -1) break;
        if (byte1 != 0xFF) continue;

        final byte2 = await file.readByte();
        if (byte2 == -1) break;
        if ((byte2 & 0xF0) != 0xF0) continue;

        final byteToReplace = await file.readByte();
        if (byteToReplace == -1) break;

        final closestBitrateKey = getClosestPossibleBitrateKey(bitrate);

        final changedByte = (byteToReplace & 0x0F) | (closestBitrateKey << 4);

        await file.setPosition(await file.position() - 1);
        await file.writeByte(changedByte);
        break;
      }

      return const Result.isSuccessful(false);
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    } finally {
      await file.close();
    }
  }

  int getClosestPossibleBitrateKey(int bitrate) {
    final possiblesBitrates = _possibleBitratesWithKeys.keys.toList();
    int closestBitrate = possiblesBitrates.first;

    for (var i = 1; i < possiblesBitrates.length; i++) {
      final closestDelta = (closestBitrate - bitrate).abs();
      final nextDelta = (possiblesBitrates[i] - bitrate).abs();

      if (nextDelta > closestDelta) {
        break;
      }

      closestBitrate = possiblesBitrates[i];
    }

    return _possibleBitratesWithKeys[closestBitrate]!;
  }
}
