abstract class CauseException implements Exception {
  CauseException({this.cause});
  String? cause;
}