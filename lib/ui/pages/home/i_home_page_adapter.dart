import 'package:flutter/material.dart';
import 'package:restaurant/restaurant.dart';

abstract class IHomePageAdapter {
  void onSearchQuery({required BuildContext context, required String query});
  onRestaurantSelected({
    required BuildContext context,
    required RestaurantModel restaurant,
  });
}

class HomePageAdapter implements IHomePageAdapter {
  final Widget Function(RestaurantModel restaurant) onSelection;
  final Widget Function(String query) onSearch;

  HomePageAdapter({required this.onSelection, required this.onSearch});

  @override
  void onSearchQuery({required BuildContext context, required String query}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => onSearch(query)));
  }

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
