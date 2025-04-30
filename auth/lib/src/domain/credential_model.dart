class CredentialModel {
  final AuthType type;
  final String? name;
  final String email;
  final String? password;

  CredentialModel({
    required this.email,
    this.name,
    this.password,
    required this.type,
  });
}

enum AuthType { email, google }
