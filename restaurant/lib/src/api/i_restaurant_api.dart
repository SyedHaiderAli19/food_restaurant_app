import 'package:restaurant/src/domain/location_model.dart';
import 'package:restaurant/src/domain/menu_model.dart';
import 'package:restaurant/src/domain/page_model.dart';
import 'package:restaurant/src/domain/restaurant_model.dart';

abstract class IRestaurantApi {
  Future<PageModel?> getAllRestaurants({
    required int pageNo,
    required int limit,
  });
  Future<PageModel?> getRestaurantByLocation({
    required int pageNo,
    required int limit,
    required LocationModel location,
  });
  Future<PageModel?> findRestaurants({
    required int pageNo,
    required int limit,
    required String searchTerm,
  });

  Future<RestaurantModel?> getRestaurant({required String id});

  Future<List<MenuModel>> getRestaurantMenu({required String restaurantId});
}
