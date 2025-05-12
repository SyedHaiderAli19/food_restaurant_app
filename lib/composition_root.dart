import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/cache/i_local_store.dart';
import 'package:food_restaurant_app/cache/local_store.dart';
import 'package:food_restaurant_app/state_management/auth/auth_bloc.dart';
import 'package:food_restaurant_app/ui/auth/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CompositionRoot {
  static late SharedPreferences _sharedPreferences;
  static late ILocalStore _localStore;
  static late String _baseUrl;
  static late http.Client _client;

  static Future<void> configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStore = LocalStore(_sharedPreferences);
    _client = http.Client();
    _baseUrl = 'http://localhost:3000';
  }

  static Widget composeAuthUI() {
    AuthApiContract _api = AuthApi(baseUrl: _baseUrl, client: _client);
    AuthManager _manager = AuthManager(api: _api);
    AuthBloc _authBloc = AuthBloc(localStore: _localStore);
    SignupServiceContract _signUpService = SignUpService(api: _api);

    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => _authBloc,
      child: AuthPage(manager: _manager, signupService: _signUpService),
    );
  }
}
