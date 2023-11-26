import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:spotify_downloader/features/data/dowload_tracks/data_sources/services/file_to_mp3_converter/file_to_mp3_converter.dart';

class FFmpegFileToMp3Converter implements FileToMp3Converter {
  @override
  Future<void> convertFileToMp3(String filePath, String audioPath) async {
    await FFmpegKit.executeWithArguments(['-i', filePath, "-vn", audioPath]);
  }
}
