import 'package:flutter/material.dart';
import 'package:food_restaurant_app/state_management/restaurant/restaurant_bloc.dart';
import 'package:food_restaurant_app/ui/pages/home/search_restaurants_page.dart';

abstract class IHomePageAdapter {
  void onSearchQuery({required BuildContext context, required String query});
}

class HomePageAdapter implements IHomePageAdapter {
  final RestaurantBloc restaurantBloc;

  HomePageAdapter({required this.restaurantBloc});

  @override
  void onSearchQuery({required BuildContext context, required String query}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (BuildContext context) => SearchRestaurantsPage(
              restaurantBloc: restaurantBloc,
              searchQuery: query,
            ),
      ),
    );
  }
}
