class Failure {
  Failure({required this.message});

  Object message;

  @override
  String toString() {
    final type = runtimeType;
    return '$type:  $message';
  }
}
