class CancellableStream {
  CancellableStream({required this.stream, required Function() cancelFunciton})
      : _cancelFunciton = cancelFunciton;

  final Stream stream;
  final Function() _cancelFunciton;
  void cancel() {
    _cancelFunciton.call();
  }
}
