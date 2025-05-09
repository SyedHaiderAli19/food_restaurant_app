import 'dart:async';
import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:food_restaurant_app/state_management/auth/auth_event.dart';
import 'package:food_restaurant_app/state_management/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialState()) {
    on<SignInEvent>(_signInEvent);
    on<SignOutEvent>(_signOutEvent);
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

  FutureOr<void> _signOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    //Initial Loading State
    emit(LoadingState());

    final result = await event.authService.signOut(token);
    if (result.asValue!.value) {
      //if the result value is present and is returned true incase of successful signout, then
      localStore.delete(token); //delete that token from the local storage
      emit(SignOutSuccessState());
    } else {
      // incase of result.asError emit the error state
      emit(ErrorState(errorMessage: 'Error While Signing Out'));
    }
  }
}
