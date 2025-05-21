import 'package:auth/auth.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/cache/i_local_store.dart';
import 'package:food_restaurant_app/cache/local_store.dart';
import 'package:food_restaurant_app/decorators/secure_client.dart';
import 'package:food_restaurant_app/state_management/auth/auth_bloc.dart';
import 'package:food_restaurant_app/state_management/helpers/header_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_bloc.dart';
import 'package:food_restaurant_app/ui/pages/auth/auth_page.dart';
import 'package:food_restaurant_app/ui/pages/auth/auth_page_adapter.dart';
import 'package:food_restaurant_app/ui/pages/home/i_home_page_adapter.dart';
import 'package:food_restaurant_app/ui/pages/home/restaurant_list_page.dart';
import 'package:food_restaurant_app/ui/pages/home/search_restaurants_page.dart';
import 'package:food_restaurant_app/ui/pages/restaurant/restaurant_page.dart';
import 'package:food_restaurant_app/ui/pages/search_restaurants/i_search_restaurants_page_adapter.dart';
import 'package:food_restaurant_app/ui/pages/search_restaurants/search_restaurants_page_adapter.dart';
import 'package:restaurant/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CompositionRoot {
  static late SharedPreferences sharedPreferences;
  static late ILocalStore localStore;
  static String baseUrl = 'http://localhost:3000';
  static late http.Client client;
  static late SecureClient secureClient;
  static late RestaurantApi restaurantApi;
  static late AuthManager manager;
  static late AuthApiContract authApi;
  static late AuthType? authType;
  static late AuthServiceContract? authService;

  static Future<void> configure() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localStore = LocalStore(sharedPreferences);
    client = http.Client();
    secureClient = SecureClient(
      client: HttpClientImp(client: client),
      localStore: localStore,
    );
    restaurantApi = RestaurantApi(baseUrl: baseUrl, httpClient: secureClient);
    authApi = AuthApi(baseUrl: baseUrl, client: client);
    manager = AuthManager(api: authApi);
    authType = await localStore.fetchAuthType();
    authService = manager.serviceContract(authType);
  }

  static Widget composeAuthUI() {
    AuthBloc authBloc = AuthBloc(localStore: localStore);
    SignupServiceContract signUpService = SignUpService(api: authApi);
    IAuthPageAdapter adapter = AuthPageAdapter(
      onUserAuthenticated: composeHomeUI,
    );
    return BlocProvider<AuthBloc>(
      create: (BuildContext context) => authBloc,
      child: AuthPage(
        manager: manager,
        signupService: signUpService,
        adapter: adapter,
      ),
    );
  }

  static Future<Widget> start() async {
    final token = await localStore.fetch();
    return token == null ? composeAuthUI() : composeHomeUI(authService!);
  }

  static Widget composeHomeUI(AuthServiceContract service) {
    RestaurantBloc restaurantBloc = RestaurantBloc(
      api: restaurantApi,
      defaultPageSize: 20,
    );

    IHomePageAdapter adapter = HomePageAdapter(
      onSearch: composeSearchRestaurantsPageWith,
      onSelection: composeRestaurantPageWith,
      onLogout: composeAuthUI,
    );

    AuthBloc authBloc = AuthBloc(localStore: localStore);

    return MultiBlocProvider(
      providers: [
        BlocProvider<RestaurantBloc>(
          create: (BuildContext context) => restaurantBloc,
        ),
        BlocProvider<AuthBloc>(create: (BuildContext context) => authBloc),
        BlocProvider<HeaderBloc>(
          create: (BuildContext context) => HeaderBloc(),
        ),
      ],
      child: RestaurantListPage(adapter: adapter, authService: authService),
    );
  }

  static Widget composeSearchRestaurantsPageWith(String query) {
    RestaurantBloc restaurantBloc = RestaurantBloc(
      api: restaurantApi,
      defaultPageSize: 10,
    );
    ISearchRestaurantsPageAdapter searchRestaurantsPageAdapter =
        SearchRestaurantPageAdapter(onSelection: composeRestaurantPageWith);
    return SearchRestaurantsPage(
      restaurantBloc: restaurantBloc,
      searchQuery: query,
      adapter: searchRestaurantsPageAdapter,
    );
  }

  static Widget composeRestaurantPageWith(RestaurantModel restaurant) {
    RestaurantBloc restaurantBloc = RestaurantBloc(
      api: restaurantApi,
      defaultPageSize: 10,
    );

    return RestaurantPage(
      restaurant: restaurant,
      restaurantBloc: restaurantBloc,
    );
  }
}
