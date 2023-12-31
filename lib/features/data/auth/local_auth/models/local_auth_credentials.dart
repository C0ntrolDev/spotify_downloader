class LocalAuthCredentials {
  LocalAuthCredentials(
      {required this.clientId, required this.clientSecret, required this.refreshToken, required this.accessToken});
      
  final String clientId;
  final String clientSecret;
  final String refreshToken;
  final String accessToken;
}
