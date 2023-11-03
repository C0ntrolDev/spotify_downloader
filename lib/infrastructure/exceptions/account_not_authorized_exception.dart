class AccountNotAuthorizedException implements Exception{
  AccountNotAuthorizedException({required this.cause});
  String cause;
}