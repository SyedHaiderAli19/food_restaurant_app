import 'package:auth/auth.dart';
import 'package:auth/src/infra/adapters/email_auth.dart';
import 'package:auth/src/infra/adapters/google_auth.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class AuthManager {
  late AuthApiContract _api;
  AuthManager({required AuthApiContract api}) {
    _api = api;
  }

  AuthServiceContract get google => GoogleAuth(_api);

  AuthServiceContract email({required String email, required String password}) {
    final emailAuth = EmailAuth(api: _api);
    emailAuth.credential(email: email, password: password);
    return emailAuth;
  }
}
