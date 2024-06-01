import 'package:spotify_downloader/core/utils/cancellation_token/cancellation_token_class.dart';

class CancellationTokenSource {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  CancellationToken get token => CancellationToken(source: this);

  void cancel() {
    _isCancelled = true;
  }
}
