abstract class RestaurantEvent {}

class GetAllRestaurantsEvent extends RestaurantEvent {
  final int page;
  GetAllRestaurantsEvent({required this.page});
}
