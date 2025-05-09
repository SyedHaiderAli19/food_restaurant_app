import 'package:async/src/result/result.dart';
import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth implements AuthServiceContract {
  final AuthApiContract _authApi;
  final GoogleSignIn? _googleSignIn;
  GoogleSignInAccount? _currentUser;

  GoogleAuth(this._authApi, [GoogleSignIn? googleSignIn])
    : this._googleSignIn =
          googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Future<Result<TokenModel>> signIn() async {
    await _handleGoogleSignIn();

    if (_currentUser == null) {
      return Result.error('Failed to Sign In with Google');
    }

    CredentialModel credential = CredentialModel(
      email: _currentUser!.email,
      type: AuthType.google,
      name: _currentUser!.displayName,
    );

    var result = await _authApi.signIn(credential);

    if (result.isError) {
      return Result.error(result.asError!);
    }

    return Result.value(TokenModel(result.asValue!.value));
  }

  @override
  Future<Result<bool>> signOut(TokenModel token) async {
    Result<bool> res = await _authApi.signOut(token);
    if (res.asValue!.value) {
      _googleSignIn!.disconnect();
    }
    return res;
  }

  _handleGoogleSignIn() async {
    try {
      _currentUser = await _googleSignIn!.signIn();
    } catch (e) {
      return;
    }
  }
}
