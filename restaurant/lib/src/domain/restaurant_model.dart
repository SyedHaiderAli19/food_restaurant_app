import 'package:restaurant/src/domain/address_model.dart';
import 'package:restaurant/src/domain/location_model.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String displayImageUrl;
  final String type;
  final double rating;
  final LocationModel location;
  final AddressModel address;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.displayImageUrl,
    required this.type,
    required this.rating,
    required this.location,
    required this.address,
  });

  static RestaurantModel fromJson(Map<String, dynamic> json) {
    final locationData = json['location'];

    double longitude = 0.0;
    double latitude = 0.0;

    if (locationData is List && locationData.length == 2) {
      longitude = _parseDouble(locationData[0]);
      latitude = _parseDouble(locationData[1]);
    } else if (locationData is Map) {
      longitude = _parseDouble(locationData['longitude']);
      latitude = _parseDouble(locationData['latitude']);
    }

    return RestaurantModel(
      id: json['id'],
      name: json['name'] ?? '',
      displayImageUrl: json['displayImgUrl'] ?? '',
      type: json['type'] ?? '',
      rating: json['rating'] ?? 0.0,
      location: LocationModel(longitude: longitude, latitude: latitude),
      address: AddressModel(
        street: json['address']?['street'] ?? '',
        city: json['address']?['city'] ?? '',
        parish: json['address']?['parish'] ?? '',
        zone: json['address']?['zone'] ?? '',
      ),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
