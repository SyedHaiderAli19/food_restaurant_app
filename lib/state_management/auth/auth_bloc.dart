import 'dart:async';
import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:food_restaurant_app/state_management/auth/auth_event.dart';
import 'package:food_restaurant_app/state_management/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialState()) {
    on<SignInEvent>(_signInEvent);
  }

  FutureOr<void> _signInEvent(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    //Initial Loading State
    emit(LoadingState());

    //use case
    final result = await event.authService.signIn();

    //incase of success emit(AuthSuccessState(tokenModel)) or ErrorState
    _setResultOfAuthState(emit, result);
  }

  void _setResultOfAuthState(
    Emitter<AuthState> emit,
    Result<TokenModel> result,
  ) {
    if (result.asError != null) {
      //if error occurs emit the error state
      emit(ErrorState(errorMessage: result.asError!.error.toString()));
      return;
    }
    //Emit SuccessState and return the token
    emit(AuthSuccessState(result.asValue!.value));
  }
}
