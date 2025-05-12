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
      "$baseUrl/search/page=$pageNo&limit=$limit&term=$searchTerm",
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
      "$baseUrl/restaurants/page=$pageNo&limit=$limit",
    );
    final result = await httpClient.get(endPoint);

    return _parseRestaurantsJson(result);
  }

  @override
  Future<RestaurantModel?> getRestaurant({required String id}) async {
    final Uri endPoint = Uri.parse("$baseUrl/restaurants/$id");
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
      "$baseUrl/restaurants/page=$pageNo&limit=$limit&longitude=${location.longitude}&latitude=${location.latitude}",
    );
    final result = await httpClient.get(endPoint);

    return _parseRestaurantsJson(result);
  }

  @override
  Future<List<MenuModel>> getRestaurantMenu({
    required String restaurantId,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurant/menu/restaurantId=$restaurantId",
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
        return null;
      }

      final Map<String, dynamic> json = jsonDecode(result.data);

      final List<RestaurantModel> restaurants =
          json['restaurants'] != null ? _restaurantsFromJson(json) : [];

      return PageModel(
        currentPage: json['metadata']['page'],
        totalPages: json['metadata']['total_pages'],
        restaurants: restaurants,
      ); 
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<RestaurantModel> _restaurantsFromJson(Map<String, dynamic> json) {
    final List<dynamic> rawRestaurantsData = json['restaurants'];

    final List<RestaurantModel> restaurants =
        rawRestaurantsData
            .map<RestaurantModel>(
              (element) => RestaurantModel.fromJson(element),
            )
            .toList();

    return restaurants;
  }
}
