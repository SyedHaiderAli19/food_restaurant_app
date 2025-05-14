import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/cache/i_local_store.dart';
import 'package:food_restaurant_app/cache/local_store.dart';
import 'package:food_restaurant_app/fake_restaurant_api.dart';
import 'package:food_restaurant_app/state_management/auth/auth_bloc.dart';
import 'package:food_restaurant_app/state_management/helpers/header_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_bloc.dart';
import 'package:food_restaurant_app/ui/pages/auth/auth_page.dart';
import 'package:food_restaurant_app/ui/pages/home/i_home_page_adapter.dart';
import 'package:food_restaurant_app/ui/pages/home/restaurant_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CompositionRoot {
  static late SharedPreferences sharedPreferences;
  static late ILocalStore localStore;
  static late String baseUrl;
  static late http.Client client;

  static Future<void> configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = http.Client();
    baseUrl = 'http://localhost:3000';
  }

  static Widget composeAuthUI() {
    AuthApiContract api = AuthApi(baseUrl: baseUrl, client: client);
    AuthManager manager = AuthManager(api: api);
    AuthBloc authBloc = AuthBloc(localStore: localStore);
    SignupServiceContract signUpService = SignUpService(api: api);

    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => authBloc,
      child: AuthPage(manager: manager, signupService: signUpService),
    );
  }

  static Widget composeHomeUI() {
    FakeRestaurantApi fakeApi = FakeRestaurantApi(50);
    RestaurantBloc restaurantBloc = RestaurantBloc(
      api: fakeApi,
      defaultPageSize: 20,
    );

    IHomePageAdapter adapter = HomePageAdapter(restaurantBloc: restaurantBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantBloc>(
          create: (BuildContext context) => restaurantBloc,
        ),
        BlocProvider<HeaderBloc>(
          create: (BuildContext context) => HeaderBloc(),
        ),
      ],
      child: RestaurantListPage(adapter: adapter),
    );
  }
}
