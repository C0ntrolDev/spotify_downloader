class Failure {
  const Failure({required this.message, this.stackTrace});

  final Object? stackTrace;
  final Object message;

  @override
  String toString() {
    return toDetailedString();
  }

  String toDetailedString() {
    final type = runtimeType;
    return '$type: "$stackTrace"  $message';
  }
}
