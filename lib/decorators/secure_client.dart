import 'package:auth/auth.dart';
import 'package:common/common.dart';
import 'package:food_restaurant_app/cache/i_local_store.dart';

class SecureClient implements IHttpClient {
  final IHttpClient client;
  final ILocalStore localStore;

  SecureClient({required this.client, required this.localStore});
  @override
  Future<HttpResult> get(Uri url, {Map<String, String>? headers}) async {
    final token = await localStore.fetch();
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token!.value;
    return await client.get(url, headers: modifiedHeader);
  }

  @override
  Future<HttpResult> post(
    Uri url,
    String body, {
    Map<String, String>? headers,
  }) async {
    final TokenModel? token = await localStore.fetch();
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token!.value;
    return await client.post(url, body, headers: modifiedHeader);
  }
}
