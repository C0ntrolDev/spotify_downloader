import 'package:spotify_downloader/core/utils/failures/failure.dart';
import 'package:spotify_downloader/core/utils/result/result.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/data_domain/tracks/domain/shared/entities/track.dart';

class TracksGettingObserver {
  Function(Result<Failure, TracksGettingEndedStatus>)? onEnded;
  Function(Iterable<Track?>)? onPartGot;
}
