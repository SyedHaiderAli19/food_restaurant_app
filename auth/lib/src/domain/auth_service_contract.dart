import 'package:auth/src/domain/token_model.dart';
import 'package:async/async.dart';

abstract class AuthServiceContract {
  Future<Result<TokenModel>> signIn();
  Future<void> signOut();
}
