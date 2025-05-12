import 'package:restaurant/src/domain/restaurant_model.dart';

class PageModel {
  final int currentPage;
  final int limit;
  final List<RestaurantModel> restaurants;

  PageModel({
    required this.currentPage,
    required this.limit,
    required this.restaurants,
  });
}
