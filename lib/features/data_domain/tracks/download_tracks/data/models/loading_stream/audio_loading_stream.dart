import 'dart:math';
import 'package:spotify_downloader/core/utils/utils.dart';


class AudioLoadingStream {
  AudioLoadingStream(
      {required Future<CancellableResult<Failure, String>> Function(Function(double percent) setLoadingPercent)
          streamFunction,
      void Function()? cancelFunction})
      : _cancelFunction = cancelFunction {
    _streamAwaiter = streamFunction.call((newPercent) => _setLoadingPercent(newPercent));
    _streamAwaiter.then((result) => onEnded?.call(result));
  }

  late final Future<CancellableResult<Failure, String>> _streamAwaiter;
  final void Function()? _cancelFunction;

  double _loadingPercent = 0;
  double get loadingPercent => _loadingPercent;
  Function(double)? onLoadingPercentChanged;

  Function(CancellableResult<Failure, String> result)? onEnded;

  void cancel() {
    _cancelFunction?.call();
  } 

  void _setLoadingPercent(double newPercent) {
    _loadingPercent = min(loadingPercent, 100);
    onLoadingPercentChanged?.call(newPercent);
  }
}
