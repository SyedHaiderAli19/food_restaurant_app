import 'package:flutter/material.dart';
import 'package:restaurant/restaurant.dart';

abstract class IHomePageAdapter {
  void onSearchQuery({required BuildContext context, required String query});
  onRestaurantSelected({
    required BuildContext context,
    required RestaurantModel restaurant,
  });
  void onUserLogout(BuildContext context);
}

class HomePageAdapter implements IHomePageAdapter {
  final Widget Function(RestaurantModel restaurant) onSelection;
  final Widget Function(String query) onSearch;
  final Widget Function() onLogout;

  HomePageAdapter({
    required this.onSelection,
    required this.onSearch,
    required this.onLogout,
  });

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

  @override
  void onUserLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => onLogout()),
      (Route<dynamic> route) => false,
    );
  }
}
