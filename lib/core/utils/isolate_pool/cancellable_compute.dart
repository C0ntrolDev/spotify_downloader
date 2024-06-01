class CancellableCompute<T> {
  CancellableCompute({required this.future, required Function() cancelFunciton})
      : _cancelFunciton = cancelFunciton;

  final Future<T> future;
  final Function() _cancelFunciton;
  void cancel() {
    _cancelFunciton.call();
  }
}