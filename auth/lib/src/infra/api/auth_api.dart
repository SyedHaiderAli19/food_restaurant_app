import 'dart:convert';
import 'package:auth/src/domain/token_model.dart';
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
    Uri endPoint = Uri.parse('$baseUrl/auth/signin');

    return await _postCredential(endPoint, credential);
  }

  @override
  Future<Result<String>> signUp(CredentialModel credential) async {
    Uri endPoint = Uri.parse('$baseUrl/auth/signup');
    return await _postCredential(endPoint, credential);
  }

  Future<Result<String>> _postCredential(
    Uri endPoint,
    CredentialModel credential,
  ) async {
    var res = await _client.post(
      endPoint,
      body: jsonEncode(Mapper.toJson(credential)),
      headers: {"Content-type": "application/json"},
    );

    if (res.statusCode != 200) {
      return Result.error('Server Error');
    }
    final json = jsonDecode(res.body);

    return json['auth_token'] != null
        ? Result.value(json['auth_token'])
        : Result.error(json['message']);
  }

  @override
  Future<Result<bool>> signOut(TokenModel token) async {
    Uri endPoint = Uri.parse(('$baseUrl + auth/signout'));
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": token.value,
    };
    var response = await _client.post(endPoint, headers: headers);

    if (response.statusCode != 200) {
      return Result.value(false);
    }
    return Result.value(true);
  }
}
