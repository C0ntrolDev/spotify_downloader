import 'cancellation_token.dart';

class CancellationTokenSource {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  CancellationToken get token => CancellationToken(source: this);

  void cancell() {
    _isCancelled = true;
  }
}
