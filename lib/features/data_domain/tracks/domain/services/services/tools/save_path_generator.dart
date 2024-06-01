import 'package:spotify_downloader/core/utils/util_methods.dart';
import 'package:spotify_downloader/features/data_domain/settings/domain/enitities/enitities.dart';

import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';
import 'package:path/path.dart' as p;

class SavePathGenerator {
  String generateSavePath(Track track, DownloadTracksSettings settings) {
    late final String savePath;
    if (settings.saveMode == SaveMode.folderForTracksCollection) {
      savePath = p.join(settings.savePath, formatStringToFileFormat(track.parentCollection.name));
    } else {
      savePath = p.join(settings.savePath, '_AllTracks');
    }

    return savePath;
  }
}
