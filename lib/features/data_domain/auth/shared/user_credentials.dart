class UserCredentials {
  UserCredentials({required this.accessToken, required this.refreshToken, required this.expiration});

  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiration;
}
