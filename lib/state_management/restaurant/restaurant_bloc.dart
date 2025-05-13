import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_event.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final IRestaurantApi api;
  final int limit;
  RestaurantBloc({required this.api, int defaultPageSize = 30})
    : limit = defaultPageSize,
      super(InitialState()) {
    on<GetAllRestaurantsEvent>(_getAllRestaurants);
    on<GetRestaurantsByLocationEvent>(_getRestaurantsByLocation);
    on<FindRestaurantsEvent>(_findRestaurants);
    on<GetRestaurantEvent>(_getRestaurant);
    on<GetRestaurantMenuEvent>(_getRestaurantMenu);
  }

  FutureOr<void> _getAllRestaurants(
    GetAllRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    //Initial State
    emit(LoadingState());

    final PageModel? pageResult = await api.getAllRestaurants(
      pageNo: event.page,
      limit: limit,
    );

    pageResult == null || pageResult.restaurants.isEmpty
        ? emit(ErrorState(errorMessage: 'No Restaurants Found'))
        : emit(PageLoadedState(page: pageResult));
  }

  FutureOr<void> _getRestaurantsByLocation(
    GetRestaurantsByLocationEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    //initial state
    emit(LoadingState());

    final PageModel? pageResult = await api.getRestaurantByLocation(
      //get page result from the api
      pageNo: event.page,
      limit: limit,
      location: event.location,
    );

    pageResult == null || pageResult.restaurants.isEmpty
        ? emit(ErrorState(errorMessage: 'No Restaurants Found'))
        : emit(PageLoadedState(page: pageResult));
  }

  FutureOr<void> _findRestaurants(
    FindRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(LoadingState());

    final PageModel? searchResults = await api.findRestaurants(
      pageNo: event.page,
      limit: limit,
      searchTerm: event.query,
    );
    searchResults == null ||
            searchResults
                .restaurants
                .isEmpty //if page result is empty or null emit error state else emit page loaded state
        ? emit(ErrorState(errorMessage: 'No Restaurants Found'))
        : emit(PageLoadedState(page: searchResults));
  }

  FutureOr<void> _getRestaurant(
    GetRestaurantEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(LoadingState());

    final RestaurantModel? restaurant = await api.getRestaurant(id: event.id);

    restaurant == null
        ? emit(ErrorState(errorMessage: "No Restaurant Found"))
        : emit(RestaurantLoadedState(restaurant: restaurant));
  }

  FutureOr<void> _getRestaurantMenu(
    GetRestaurantMenuEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(LoadingState());

    final List<MenuModel> menus = await api.getRestaurantMenu(
      restaurantId: event.restaurantId,
    );

    menus.isEmpty
        ? emit(ErrorState(errorMessage: "No Menu Found For This Restaurant"))
        : emit(MenuLoadedState(menus: menus));
  }
}
