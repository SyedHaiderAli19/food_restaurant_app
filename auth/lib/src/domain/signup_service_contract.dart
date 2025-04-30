import 'package:auth/src/domain/token_model.dart';
import 'package:async/async.dart';

abstract class SignupServiceContract {
  Future<Result<TokenModel>> signUp({
    required String email,
    required String name,
    required String password,
  });
}
