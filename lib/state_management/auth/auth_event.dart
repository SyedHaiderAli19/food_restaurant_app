import 'package:auth/auth.dart';
import 'package:food_restaurant_app/models/user_model.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final AuthServiceContract authService;
  final String? email;
  final String? password;
  final AuthType type;
  SignInEvent({
    required this.authService,
    required this.type,
    this.email,
    this.password,
  });
}

class SignOutEvent extends AuthEvent {
  final AuthServiceContract authService;
  SignOutEvent({required this.authService});
}

class SignUpEvent extends AuthEvent {
  final SignupServiceContract signUpService;
  final UserModel userModel;

  SignUpEvent({required this.signUpService, required this.userModel});
}
