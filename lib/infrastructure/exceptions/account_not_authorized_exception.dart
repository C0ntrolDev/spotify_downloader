import 'package:spotify_downloader/infrastructure/exceptions/base/cause_exception.dart';

class AccountNotAuthorizedException extends CauseException{
  AccountNotAuthorizedException({super.cause});
}