import 'package:async/src/result/result.dart';
import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class EmailAuth implements AuthServiceContract {
  final AuthApiContract api;
  CredentialModel? _credential;
  TokenModel? _tokenModel;

  EmailAuth({required this.api});

  void credential({required String email, required String password}) {
    _credential = CredentialModel(
      email: email,
      password: password,
      type: AuthType.email,
    );
  }

  @override
  Future<Result<TokenModel>> signIn() async {
    assert(_credential != null);

    var result = await api.signIn(_credential!);

    if (result.isError) {
      return result.asError!;
    }

    return Result.value(TokenModel(result.asValue!.value));
  }

  @override
  Future<Result<bool>> signOut(TokenModel token) async {
    return await api.signOut(_tokenModel!);
  }

}
