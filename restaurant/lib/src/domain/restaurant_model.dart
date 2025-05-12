import 'package:restaurant/src/domain/address_model.dart';
import 'package:restaurant/src/domain/location_model.dart';

class RestaurantClass {
  final String id;
  final String name;
  final String displayImageUrl;
  final String type;
  final LocationModel location;
  final AddressModel address;

  RestaurantClass({
    required this.id,
    required this.name,
    required this.displayImageUrl,
    required this.type,
    required this.location,
    required this.address,
  });
}
