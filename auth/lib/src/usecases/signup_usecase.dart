import 'package:auth/src/domain/signup_service_contract.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:async/async.dart';

class SignupUsecase {
  final SignupServiceContract _signupServiceContract;

  SignupUsecase(this._signupServiceContract);

  Future<Result<TokenModel>> execute(
    String name,
    String email,
    String password,
  ) async {
    return await _signupServiceContract.signUp(
      email: email,
      name: name,
      password: password,
    );
  }
}
