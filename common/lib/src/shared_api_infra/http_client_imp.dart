import 'package:common/src/shared_api_infra/i_http_client.dart';
import 'package:http/http.dart' as http;

class HttpClientImp implements IHttpClient {
  final http.Client client;

  HttpClientImp({required this.client});

  @override
  Future<HttpResult> get(Uri url, {Map<String, String>? headers}) async {
    try {
      final response = await client.get(url, headers: headers);
      return HttpResult(
        data: response.body,
        status: _setStatus(response.statusCode),
      );
    } catch (e) {
      return HttpResult(
        data: '{"error": "Network error"}',
        status: Status.failure,
      );
    }
  }

  @override
  Future<HttpResult> post(
    Uri url,
    String body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.post(url, body: body, headers: headers);
      return HttpResult(
        data: response.body,
        status: _setStatus(response.statusCode),
      );
    } catch (e) {
      return HttpResult(
        data: '{"error": "Network error"}',
        status: Status.failure,
      );
    }
  }

  Status _setStatus(int statusCode) {
    return (statusCode >= 200 && statusCode < 300)
        ? Status.success
        : Status.failure;
  }
}
