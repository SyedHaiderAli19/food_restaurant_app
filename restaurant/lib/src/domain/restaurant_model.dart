import 'package:restaurant/src/domain/address_model.dart';
import 'package:restaurant/src/domain/location_model.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String displayImageUrl;
  final String type;
  final LocationModel location;
  final AddressModel address;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.displayImageUrl,
    required this.type,
    required this.location,
    required this.address,
  });

  static fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      displayImageUrl: json['image_url'],
      type: json['type'],
      location: LocationModel(
        longitude: json['location']['longitude'],
        latitude: json['location']['latitude'],
      ),
      address: AddressModel(
        street: json['address']['street'],
        city: json['address']['city'],
        parish: json['address']['parish'],
        zone: json['address']['zone'],
      ),
    );
  }
}
