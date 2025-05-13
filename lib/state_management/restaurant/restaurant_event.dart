import 'package:restaurant/restaurant.dart';

abstract class RestaurantEvent {}

class GetAllRestaurantsEvent extends RestaurantEvent {
  final int page;
  GetAllRestaurantsEvent({required this.page});
}

class GetRestaurantsByLocationEvent extends RestaurantEvent {
  final int page;
  LocationModel location;

  GetRestaurantsByLocationEvent({required this.page, required this.location});
}

class FindRestaurantsEvent extends RestaurantEvent {
  final int page;
  final String query;

  FindRestaurantsEvent({required this.page, required this.query});
}

class GetRestaurantEvent extends RestaurantEvent {
  final String id;

  GetRestaurantEvent({required this.id});
}

class GetRestaurantMenuEvent extends RestaurantEvent {
  final String restaurantId;

  GetRestaurantMenuEvent({required this.restaurantId});
}
