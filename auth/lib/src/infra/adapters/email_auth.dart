import 'package:async/src/result/result.dart';
import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/domain/signup_service_contract.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class EmailAuth implements AuthServiceContract, SignupServiceContract {
  final AuthApiContract _api;
  CredentialModel? _credential;

  EmailAuth(this._api);

  @override
  Future<Result<TokenModel>> signIn() async {
    assert(_credential != null);

    var result = await _api.signIn(_credential!);

    if (result.isError) {
      return result.asError!;
    }

    return Result.value(TokenModel(result.asValue!.value));
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Result<TokenModel>> signUp({
    required String email,
    required String name,
    required String password,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
