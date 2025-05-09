import 'package:async/src/result/result.dart';
import 'package:auth/auth.dart';
import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class SignUpService implements SignupServiceContract {
  final AuthApiContract api;

  SignUpService({required this.api});

  @override
  Future<Result<TokenModel>> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    CredentialModel credential = CredentialModel(
      email: email,
      type: AuthType.email,
      name: name,
      password: password,
    );

    var result = await api.signUp(credential);

    if (result.isError) {
      return result.asError!;
    }

    return Result.value(TokenModel(result.asValue!.value));
  }
}
