import 'dart:convert';
import 'package:restaurant/src/api/i_restaurant_api.dart';
import 'package:restaurant/src/domain/location_model.dart';
import 'package:restaurant/src/domain/menu_model.dart';
import 'package:restaurant/src/domain/restaurant_model.dart';
import 'package:http/http.dart' as http;

class RestaurantApi implements IRestaurantApi {
  final http.Client httpClient;
  final String baseUrl;

  RestaurantApi({required this.baseUrl, required this.httpClient});

  @override
  Future<List<RestaurantModel>> findRestaurants({
    required int pageNo,
    required String searchTerm,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/search/page=$pageNo&term=$searchTerm",
    );

    final http.Response response = await httpClient.get(endPoint);

    return _parseRestaurantsJson(response);
  }

  @override
  Future<List<RestaurantModel>> getAllRestaurants({required int pageNo}) async {
    final Uri endPoint = Uri.parse("$baseUrl/restaurants/page=$pageNo");
    final http.Response response = await httpClient.get(endPoint);

    return _parseRestaurantsJson(response);
  }

  @override
  Future<RestaurantModel?> getRestaurant({required String id}) async {
    final Uri endPoint = Uri.parse("$baseUrl/restaurants/$id");
    final http.Response response = await httpClient.get(endPoint);

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);

    return RestaurantModel.fromJson(json);
  }

  @override
  Future<List<RestaurantModel>> getRestaurantByLocation({
    required int pageNo,
    required LocationModel location,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurants/page=$pageNo&longitude=${location.longitude}&latitude=${location.latitude}",
    );
    final response = await httpClient.get(endPoint);

    return _parseRestaurantsJson(response);
  }

  @override
  Future<List<MenuModel>> getRestaurantMenu({
    required String restaurantId,
  }) async {
    final Uri endPoint = Uri.parse(
      "$baseUrl/restaurant/menu/restaurantId=$restaurantId",
    );
    final http.Response response = await httpClient.get(endPoint);
    try {
      if (response.statusCode != 200) {
        return <MenuModel>[];
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

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

  _parseRestaurantsJson(http.Response response) {
    try {
      if (response.statusCode != 200) {
        return <RestaurantModel>[];
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

      return json['restaurants'] != null
          ? _restaurantsFromJson(json)
          : <RestaurantModel>[];
    } catch (e) {
      print(e.toString());
      return <RestaurantModel>[];
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
