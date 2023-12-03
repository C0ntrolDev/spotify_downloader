import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token_source.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';
import 'package:spotify_downloader/features/domain/tracks/shared/entities/track.dart';

class TracksGettingController {
  TracksGettingController({required CancellationTokenSource cancellationTokenSource})
      : _cancellationTokenSource = cancellationTokenSource;

  final CancellationTokenSource _cancellationTokenSource;

  Function(Result<Failure, TracksGettingEndedStatus>)? onEnded;
  Function(Iterable<Track?>)? onPartGot;

  void cancelGetting() => _cancellationTokenSource.cancel();
}
