import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:async/async.dart';

class SignoutUsecase {
  final AuthServiceContract _authServiceContract;

  SignoutUsecase(this._authServiceContract);

  Future<Result<bool>> execute(TokenModel token) async {
    Result<bool> isSignedOut = await _authServiceContract.signOut(token);
    return isSignedOut;
  }
}
