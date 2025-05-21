import 'package:auth/auth.dart';

abstract class ILocalStore {
  Future<TokenModel>? fetch();
  delete({required TokenModel token});
  Future<void> save(TokenModel token);
  Future<AuthType?> fetchAuthType();
  Future<void> saveAuthType(AuthType type);
}
