import 'dart:convert';
import 'package:common/common.dart';
import 'package:restaurant/src/api/i_restaurant_api.dart';
import 'package:restaurant/src/domain/location_model.dart';
import 'package:restaurant/src/domain/menu_model.dart';
import 'package:restaurant/src/domain/page_model.dart';
import 'package:restaurant/src/domain/restaurant_model.dart';

class RestaurantApi implements IRestaurantApi {
  final IHttpClient httpClient;
  final String baseUrl;

  RestaurantApi({required this.baseUrl, required this.httpClient});

  @override
  Future<PageModel?> findRestaurants({
    required int pageNo,
    required int limit,
    required String searchTerm,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurant/search?page=$pageNo&limit=$limit&query=$searchTerm",
    );

    final HttpResult result = await httpClient.get(endPoint);

    return _parseRestaurantsJson(result);
  }

  @override
  Future<PageModel?> getAllRestaurants({
    required int pageNo,
    required int limit,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurant/?page=$pageNo&limit=$limit",
    );
    final result = await httpClient.get(endPoint);

    return _parseRestaurantsJson(result);
  }

  @override
  Future<RestaurantModel?> getRestaurant({required String id}) async {
    final Uri endPoint = Uri.parse("$baseUrl/restaurant/restaurant/$id");
    final result = await httpClient.get(endPoint);

    if (result.status == Status.failure) {
      return null;
    }

    final json = jsonDecode(result.data);

    return RestaurantModel.fromJson(json);
  }

  @override
  Future<PageModel?> getRestaurantByLocation({
    required int pageNo,
    required int limit,
    required LocationModel location,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurant/location?page=$pageNo&limit=$limit&longitude=${location.longitude}&latitude=${location.latitude}",
    );
    final result = await httpClient.get(endPoint);

    return _parseRestaurantsJson(result);
  }

  @override
  Future<List<MenuModel>> getRestaurantMenu({
    required String restaurantId,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurant/restaurant/menu/$restaurantId",
    );
    final HttpResult result = await httpClient.get(endPoint);
    try {
      if (result.status == Status.failure) {
        return <MenuModel>[];
      }

      final Map<String, dynamic> json = jsonDecode(result.data);

      if (json['menu'] == null) {
        return <MenuModel>[];
      }

      final List<dynamic> rawMenus = json['menu'];

      final List<MenuModel> menus =
          rawMenus
              .map<MenuModel>((element) => MenuModel.fromJson(element))
              .toList();
      return menus;
    } catch (e) {
      print(e.toString());
      return <MenuModel>[];
    }
  }

  PageModel? _parseRestaurantsJson(HttpResult result) {
    try {
      if (result.status == Status.failure) {
        print('[RestaurantApi] Failed HTTP call');
        return null;
      }

      final Map<String, dynamic> json = jsonDecode(result.data);
      print('[RestaurantApi] Raw JSON decoded successfully');

      if (json['restaurants'] == null || json['metadata'] == null) {
        print('[RestaurantApi] Missing restaurants or metadata in JSON');
        return null;
      }

      final restaurants = _restaurantsFromJson(json);

      final currentPage = json['metadata']['page'];
      final totalPages = json['metadata']['total_pages'];

      if (currentPage == null || totalPages == null) {
        print('[RestaurantApi] Invalid pagination metadata');
        return null;
      }

      return PageModel(
        currentPage: currentPage,
        totalPages: totalPages,
        restaurants: restaurants,
      );
    } catch (e, stack) {
      print('[RestaurantApi] Parsing error: $e');
      print(stack);
      return null;
    }
  }

  List<RestaurantModel> _restaurantsFromJson(Map<String, dynamic> json) {
    final List<dynamic> rawRestaurantsData = json['restaurants'];
    final List<RestaurantModel> restaurants = [];

    for (var i = 0; i < rawRestaurantsData.length; i++) {
      try {
        final restaurant = RestaurantModel.fromJson(rawRestaurantsData[i]);
        restaurants.add(restaurant);
      } catch (e) {
        print('[RestaurantApi] Failed to parse restaurant at index $i: $e');
      }
    }

    return restaurants;
  }
}
