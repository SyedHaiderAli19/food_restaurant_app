import 'dart:async';
import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:food_restaurant_app/cache/i_local_store.dart';
import 'package:food_restaurant_app/state_management/auth/auth_event.dart';
import 'package:food_restaurant_app/state_management/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ILocalStore localStore;
  AuthBloc({required this.localStore}) : super(InitialState()) {
    on<SignInEvent>(_signInEvent);
    on<SignOutEvent>(_signOutEvent);
    on<SignUpEvent>(_signUpEvent);
  }
  //sign in use case
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

  //signout usecase
  FutureOr<void> _signOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    //Initial Loading State
    emit(LoadingState());

    //fetch the token from the local storage
    final token = await localStore.fetch();

    final result = await event.authService.signOut(token);
    if (result.asValue!.value) {
      //if the result value is present and is returned true incase of successful signout, then
      localStore.delete(
        token: token,
      ); //delete that token from the local storage
      emit(SignOutSuccessState());
    } else {
      // incase of result.asError emit the error state
      emit(ErrorState(errorMessage: 'Error While Signing Out'));
    }
  }

  //sign up usecase
  FutureOr<void> _signUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    //initial state
    emit(LoadingState());

    //perform sign up usecase
    final result = await event.signUpService.signUp(
      email: event.userModel.email,
      name: event.userModel.name,
      password: event.userModel.password,
    );

    //emit success or error
    _setResultOfAuthState(emit, result);
  }
}
