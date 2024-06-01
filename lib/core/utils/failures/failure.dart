class Failure {
  const Failure({required this.message});

  final Object message;

  @override
  String toString() {
    final type = runtimeType;
    return '$type:  $message';
  }
}
