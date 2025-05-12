import 'package:auth/src/domain/credential_model.dart';
import 'package:auth/src/domain/token_model.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

void main() {
  CredentialModel credential = CredentialModel(
    //creates a user credential
    email: 'abc@mail.com',
    type: AuthType.email,
    name: 'abc',
    password: 'abcde',
  );
  AuthApi? sut;
  http.Client client;
  String baseUrl = 'http://localhost:3000';

  setUp(() {
    // set up the test case
    client = http.Client();
    sut = AuthApi(baseUrl: baseUrl, client: client);
  });

  group('signin', () {
    test('should return json web token when successful', () async {
      //arrange

      //act

      Result<String> result = await sut!.signIn(credential); //signs in

      //assert

      expect(
        result.asValue!.value,
        isNotEmpty,
      ); //expecting to return a auth token not empty
    });

    test('should return error with invalid credential', () async {
      CredentialModel fakeCredential = CredentialModel(
        email: 'fake@mail.com',
        type: AuthType.email,
        password: 'fakepass',
        name: 'fake',
      );

      Result<String> result = await sut!.signIn(fakeCredential);

      expect(result.asError!.error, isNotEmpty);
    });
  });

  group('signout', () {
    test('should sign out and return true', () async {
      final tokenString = await sut!.signIn(credential);
      final token = TokenModel(tokenString.asValue!.value);

      final res = await sut!.signOut(token);

      expect(res.asValue!.value, true);
    });
  });
}
