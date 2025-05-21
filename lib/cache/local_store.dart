import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:food_restaurant_app/cache/i_local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_TOKEN = 'CACHED_TOKEN';
const CACHED_AUTH = 'CACHED_AUTH';

class LocalStore implements ILocalStore {
  final SharedPreferences sharedPreferences;

  LocalStore(this.sharedPreferences);

  @override
  delete({required TokenModel token}) {
    sharedPreferences.remove(CACHED_TOKEN);
  }

  @override
  Future<TokenModel>? fetch() {
    final tokenString = sharedPreferences.getString(CACHED_TOKEN);

    if (tokenString != null) {
      return Future.value(TokenModel(tokenString));
    }

    return null;
  }

  @override
  Future<void> save(TokenModel token) async {
    sharedPreferences.setString(CACHED_TOKEN, token.value);
  }

  @override
  Future<AuthType?> fetchAuthType() async {
    final authType = sharedPreferences.getString(CACHED_AUTH);
    if (authType == null) return null;

    try {
      return AuthType.values.firstWhere((val) => val.toString() == authType);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveAuthType(AuthType type) {
    return sharedPreferences.setString(CACHED_AUTH, type.toString());
  }
}
