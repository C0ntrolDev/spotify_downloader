class AuthResponse {
  AuthResponse({required this.refreshToken, required this.accessToken, required this.expiration});
  
  final String refreshToken;
  final String accessToken;
  final DateTime expiration;
}
