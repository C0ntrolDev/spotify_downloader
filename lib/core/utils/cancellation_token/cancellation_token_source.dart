import 'dart:async';

import 'package:spotify_downloader/core/utils/cancellation_token/cancellation_token_class.dart';

class CancellationTokenSource {
  final StreamController _cancellationStreamController = StreamController<void>();
  late final Stream _cancellationStream;
  Stream get cancellationStream => _cancellationStream;

  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  CancellationToken get token => CancellationToken(source: this);

  CancellationTokenSource() {
    _cancellationStream = _cancellationStreamController.stream.asBroadcastStream();
  }

  void cancel() {
    if (!_isCancelled) {
      _cancellationStreamController.add(null);
    }
    _isCancelled = true;
  }
}
