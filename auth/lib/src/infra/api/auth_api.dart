import 'dart:convert';
import 'package:auth/src/infra/api/mapper.dart';
import 'package:http/http.dart' as http;
import 'package:async/src/result/result.dart';
import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

class AuthApi implements AuthApiContract {
  final http.Client _client;
  String baseUrl;

  AuthApi(this.baseUrl, this._client);

  @override
  Future<Result<String>> signIn(CredentialModel credential) async {
    var endPoint = ('$baseUrl/auth/signin') as Uri;

    return await _postCredential(endPoint, credential);
  }

  @override
  Future<Result<String>> signUp(CredentialModel credential) async {
    var endPoint = ('$baseUrl/auth/signup') as Uri;
    return await _postCredential(endPoint, credential);
  }

  Future<Result<String>> _postCredential(
    Uri endPoint,
    CredentialModel credential,
  ) async {
    var res = await _client.post(endPoint, body: Mapper.toJson(credential));

    if (res.statusCode != 200) {
      return Result.error('Server Error');
    }
    var json = jsonDecode(res.body);

    return json['auth_token'] != null
        ? Result.value(json['auth_token'])
        : Result.error(json['message']);
  }
}
