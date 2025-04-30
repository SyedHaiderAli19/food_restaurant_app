import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:async/async.dart';

class SigninUsecase {
  final AuthServiceContract _authServiceContract;

  SigninUsecase(this._authServiceContract);

  Future<Result<TokenModel>> execute() async {
    return await _authServiceContract.signIn();
  }
}
