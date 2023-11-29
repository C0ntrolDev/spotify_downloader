import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token_source.dart';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/features/domain/tracks/network_tracks/entities/tracks_getting_ended_status.dart';

class TracksGettingController {
  TracksGettingController({required CancellationTokenSource cancellationTokenSource})
      : _cancellationTokenSource = cancellationTokenSource;
      
  final CancellationTokenSource _cancellationTokenSource;

  Function(Result<Failure, TracksGettingEndedStatus>)? onEnded;
  Function()? onPartGetted;

  void cancelGetting() => _cancellationTokenSource.cancel();
}
