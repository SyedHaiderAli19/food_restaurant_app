import 'package:restaurant/src/domain/location_model.dart';
import 'package:restaurant/src/domain/menu_model.dart';
import 'package:restaurant/src/domain/restaurant_model.dart';

abstract class IRestaurantApi {
  Future<List<RestaurantModel>> getAllRestaurants({required int pageNo});
  Future<List<RestaurantModel>> getRestaurantByLocation({
    required int pageNo,
    required LocationModel location,
  });
  Future<List<RestaurantModel>> findRestaurants({
    required int pageNo,
    required String searchTerm,
  });

  Future<RestaurantModel> getRestaurant({required String id});

  Future<MenuModel> getRestaurantMenu({required String restaurantId});
}
