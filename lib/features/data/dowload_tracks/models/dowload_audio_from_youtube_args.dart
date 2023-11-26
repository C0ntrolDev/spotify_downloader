import 'package:spotify_downloader/features/data/dowload_tracks/models/metadata/audio_metadata.dart';

class DowloadAudioFromYoutubeArgs {
    DowloadAudioFromYoutubeArgs({
    required this.youtubeUrl,
    required this.saveDirectoryPath,
    required this.audioMetadata
  });


  final String youtubeUrl;
  final String saveDirectoryPath;

  final AudioMetadata audioMetadata;
}
