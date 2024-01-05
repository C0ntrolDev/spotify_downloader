class LocalAuthCredentials {
  LocalAuthCredentials(
      {required this.clientId, required this.clientSecret, required this.refreshToken, required this.accessToken, required this.expirationInMillisecondsSinceEpoch});
      
  final String clientId;
  final String clientSecret;
  final String refreshToken;
  final String accessToken;
  final String expirationInMillisecondsSinceEpoch;
}
