import 'metadata/audio_metadata.dart';

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
