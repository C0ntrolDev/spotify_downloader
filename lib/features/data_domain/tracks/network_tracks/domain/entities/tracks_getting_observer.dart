import 'package:spotify_downloader/core/utils/utils.dart';
import 'package:spotify_downloader/features/data_domain/tracks/network_tracks/domain/domain.dart';
import 'package:spotify_downloader/features/data_domain/tracks/shared/domain/domain.dart';

class TracksGettingObserver {
  Function(Result<Failure, TracksGettingEndedStatus>)? onEnded;
  Function(Iterable<Track?>)? onPartGot;
}
