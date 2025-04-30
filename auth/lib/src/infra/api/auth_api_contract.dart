import 'package:auth/src/domain/credential_model.dart';
import 'package:async/async.dart';

abstract class AuthApiContract {
  Future<Result<String>> signIn(CredentialModel credential);
  Future<Result<String>> signUp(CredentialModel credential);
}
