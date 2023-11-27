import 'dart:math';
import 'package:spotify_downloader/core/util/failures/failure.dart';
import 'package:spotify_downloader/core/util/result/result.dart';
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token.dart';
import 'package:spotify_downloader/core/util/cancellation_token/cancellation_token_source.dart';
import 'package:spotify_downloader/features/data/tracks/dowload_tracks/models/loading_stream/loading_result_status.dart';

class LoadingStream {
  LoadingStream(
      Future<Result<Failure, LoadingResultStatus>> Function(CancellationToken cancellationToken,
              Function(double percent) setLoadingPercent)
        streamFunction) {
          _streamAwaiter = streamFunction.call(_cancellationTokenSource.token, (newPercent) => _setLoadingPercent(newPercent));
          _streamAwaiter.then((result) => onEnded?.call(result));
        }

  final CancellationTokenSource _cancellationTokenSource = CancellationTokenSource();
  late final Future<Result<Failure, LoadingResultStatus>> _streamAwaiter;

  double _loadingPercent = 0;
  double get loadingPercent => _loadingPercent;
  Function(double)? onLoadingPercentChanged;

  Function(Result<Failure, LoadingResultStatus> result)? onEnded;

  void cancel() => _cancellationTokenSource.cancell();

  void _setLoadingPercent(double newPercent) {
    _loadingPercent = min(loadingPercent, 100);
    onLoadingPercentChanged?.call(newPercent);
  }
}
