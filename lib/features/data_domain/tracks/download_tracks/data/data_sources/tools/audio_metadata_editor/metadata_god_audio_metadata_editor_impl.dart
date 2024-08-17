import 'dart:io';
import 'dart:typed_data';

import 'package:metadata_god/metadata_god.dart';
import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/data_sources/tools/audio_metadata_editor/audio_metadata_editor.dart';
import 'package:spotify_downloader/features/data_domain/tracks/download_tracks/data/models/metadata/audio_metadata.dart';
import 'package:http/http.dart' as http;

class MetadataGodAudioMetadataEditorImpl implements AudioMetadataEditor {
  @override
  Future<Result<Failure, void>> changeAudioMetadata(
      {required String audioPath, required AudioMetadata audioMetadata}) async {
    Uint8List? imageData;

    if (audioMetadata.album?.imageUrl != null) {
      try {
        final getImageResponce = await http.get(Uri.parse(audioMetadata.album!.imageUrl!));
        if (getImageResponce.statusCode == 200) {
          imageData = getImageResponce.bodyBytes;
        }
      } on SocketException {
        return const Result.notSuccessful(NetworkFailure());
      }
    }
    
    try {
      await MetadataGod.writeMetadata(
          file: audioPath,
          metadata: Metadata(
              title: audioMetadata.name,
              artist: audioMetadata.artists?.join(', '),
              durationMs: audioMetadata.durationMs,
              year: audioMetadata.realiseYear,
              album: audioMetadata.album?.name,
              trackNumber: audioMetadata.trackNumber,
              trackTotal: audioMetadata.album?.totalTracksCount,
              discNumber: audioMetadata.discNumber,
              picture: (() {
                if (imageData != null) {
                  const mimeType = 'image/jpg';
                  return Picture(mimeType: mimeType, data: imageData);
                }
                return null;
              }).call(),
              albumArtist: audioMetadata.album?.artists?.join(', ')));
    } catch (e, s) {
      return Result.notSuccessful(Failure(message: e, stackTrace: s));
    }

    return const Result.isSuccessful(null);
  }
}
