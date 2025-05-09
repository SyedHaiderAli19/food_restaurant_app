import 'package:auth/src/domain/credential_model.dart';

class Mapper {
  static Map<String, dynamic> toJson(CredentialModel credential) => {
    'type': credential.type.toString().split('.').last,
    'name': credential.name,
    'email': credential.email,
    'password': credential.password,
  };
}
