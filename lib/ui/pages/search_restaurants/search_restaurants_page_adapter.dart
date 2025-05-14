import 'package:flutter/material.dart';
import 'package:food_restaurant_app/ui/pages/search_restaurants/i_search_restaurants_page_adapter.dart';
import 'package:restaurant/restaurant.dart';

class SearchRestaurantPageAdapter implements ISearchRestaurantsPageAdapter {
  final Widget Function(RestaurantModel restaurant) onSelection;

  SearchRestaurantPageAdapter({required this.onSelection});

  @override
  void onRestaurantSelected({
    required BuildContext context,
    required RestaurantModel restaurant,
  }) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => onSelection(restaurant)));
  }
}
