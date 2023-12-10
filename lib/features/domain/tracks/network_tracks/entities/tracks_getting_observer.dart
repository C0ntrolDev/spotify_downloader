import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TracksGettingObserver {
  TracksGettingObserver({required Function() cancelGetting}) : _cancelGetting = cancelGetting ;

  final Function() _cancelGetting;

  Function(Result<Failure, TracksGettingEndedStatus>)? onEnded;
  Function(Iterable<Track?>)? onPartGot;

  void cancelGetting() => _cancelGetting.call();
}
