import 'package:auth/auth.dart';
import 'package:auth/src/infra/adapters/google_auth.dart';

class AuthManager {
  late AuthApiContract _api;
  AuthManager({required AuthApiContract api}) {
    _api = api;
  }

  AuthServiceContract? serviceContract(AuthType? type) {
    final AuthServiceContract? service;
    switch (type) {
      case AuthType.email:
        service = EmailAuth(api: _api);
        break;
      case AuthType.google:
        service = GoogleAuth(_api);
        break;
      case null:
        service = null;
    }
    return service;
  }
}
