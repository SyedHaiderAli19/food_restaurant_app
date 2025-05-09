import 'package:auth/auth.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final AuthServiceContract authService;
  SignInEvent({required this.authService});

}
