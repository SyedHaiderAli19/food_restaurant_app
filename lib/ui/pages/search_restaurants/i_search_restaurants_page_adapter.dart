import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant/restaurant.dart';

abstract class ISearchRestaurantsPageAdapter {
  void onRestaurantSelected({
    required BuildContext context,
    required RestaurantModel restaurant,
  });
}

