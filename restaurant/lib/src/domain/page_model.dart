import 'package:restaurant/src/domain/restaurant_model.dart';

class PageModel {
  final int currentPage;
  final int totalPages;
  bool get isLast => currentPage == totalPages;
  final List<RestaurantModel> restaurants;

  PageModel({
    required this.currentPage,
    required this.totalPages,
    required this.restaurants,
  });
}
