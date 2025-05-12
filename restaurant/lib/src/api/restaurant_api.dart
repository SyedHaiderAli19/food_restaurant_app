import 'dart:convert';
import 'dart:io';

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
  }) {
    // TODO: implement findRestaurants
    throw UnimplementedError();
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
  Future<MenuModel> getRestaurantMenu({required String restaurantId}) {
    // TODO: implement getRestaurantMenu
    throw UnimplementedError();
  }

  _parseRestaurantsJson(http.Response response) {
    try {
      if (response.statusCode != 200) {
        return [];
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

      return json['restaurants'] != null ? _restaurantsFromJson(json) : [];
    } catch (e) {}
  }

  List<RestaurantModel> _restaurantsFromJson(Map<String, dynamic> json) {
    final List<RestaurantModel> restaurants = json['restaurants'];

    return restaurants
        .map<RestaurantModel>((element) => RestaurantModel.fromJson(json))
        .toList();
  }
}
