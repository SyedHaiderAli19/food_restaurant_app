import 'package:common/src/shared_api_infra/i_http_client.dart';
import 'package:http/http.dart' as http;

class HttpClientImp implements IHttpClient {
  final http.Client client;

  HttpClientImp({required this.client});

  @override
  Future<HttpResult> get(Uri url, {Map<String, String>? headers}) async {
    final response = await client.get(url);

    return HttpResult(data: response.body, status: _setStatus(response));
  }

  @override
  Future<HttpResult> post(
    Uri url,
    String body, {
    Map<String, String>? headers,
  }) async {
    final response = await client.post(url, body: body);

    return HttpResult(data: response.body, status: _setStatus(response));
  }

  Status _setStatus(http.Response response) {
    if (response.statusCode != 200) {
      return Status.failure;
    }
    return Status.success;
  }
}
