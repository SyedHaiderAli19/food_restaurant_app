import 'package:auth/src/domain/credential_model.dart';
import 'package:async/async.dart';
import 'package:auth/src/domain/token_model.dart';

abstract class AuthApiContract {
  Future<Result<String>> signIn(CredentialModel credential);
  Future<Result<String>> signUp(CredentialModel credential);
  Future<Result<bool>> signOut(TokenModel token);
}
