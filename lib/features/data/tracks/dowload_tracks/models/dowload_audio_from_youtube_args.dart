import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/metadata/audio_metadata.dart';

class DownloadAudioFromYoutubeArgs {
    DownloadAudioFromYoutubeArgs({
    required this.youtubeUrl,
    required this.saveDirectoryPath,
    required this.audioMetadata
  });


  final String youtubeUrl;
  final String saveDirectoryPath;

  final AudioMetadata audioMetadata;
}
