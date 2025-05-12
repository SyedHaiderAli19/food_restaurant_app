import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_event.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final IRestaurantApi api;
  final int pageSize;
  RestaurantBloc({required this.api, int defaultPageSize = 30})
    : pageSize = defaultPageSize,
      super(InitialState()) {
    on<GetAllRestaurantsEvent>(_getAllRestaurants);
  }

  FutureOr<void> _getAllRestaurants(
    GetAllRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    //Initial State
    _startLoading();

    final pageResult = await api.getAllRestaurants(
      pageNo: event.page,
      limit: pageSize,
    );

    pageResult == null || pageResult!.restaurants.isEmpty
        ? _showError('No Restaurants Found')
        : _setPageData(pageResult);
  }

  _startLoading() {
    emit(LoadingState());
  }

  _setPageData(PageModel pageResult) {
    emit(PageLoadedState(page: pageResult));
  }

  _showError(String errorMessage) {
    emit(ErrorState(errorMessage: errorMessage));
  }
}
