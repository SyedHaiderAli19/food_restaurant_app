import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class InitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSuccessState extends AuthState {
  final TokenModel token;
  AuthSuccessState(this.token);

  @override
  List<Object?> get props => [token];
}

class ErrorState extends AuthState {
  final String errorMessage; //needs an error message from the backend
  ErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [];
}

class SignOutSuccessState extends AuthState {
  @override
  List<Object?> get props => [];
}
