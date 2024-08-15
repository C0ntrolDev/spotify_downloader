import 'package:spotify_downloader/core/utils/utils.dart';

abstract class AudioBitrateEditor {
  Future<Result<Failure, bool>> changeBitrate(String path, int bitrate);
}
