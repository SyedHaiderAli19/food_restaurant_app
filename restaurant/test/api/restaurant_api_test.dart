import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant/src/api/restaurant_api.dart';
import 'package:restaurant/src/domain/location_model.dart';
import 'package:restaurant/src/domain/restaurant_model.dart';
import 'package:restaurant/src/domain/menu_model.dart';

import '../mock_client.mocks.dart';

void main() {
  late RestaurantApi api;
  late MockClient mockClient;

  const baseUrl = 'https://fakeapi.com';

  setUp(() {
    mockClient = MockClient();
    api = RestaurantApi(baseUrl: baseUrl, httpClient: mockClient);
  });

  Map<String, dynamic> restaurantJson(String id) => {
    'id': id,
    'name': 'Test Restaurant',
    'image_url': 'https://image.com/restaurant.jpg',
    'type': 'Fast Food',
    'location': {'longitude': 73.1, 'latitude': 33.6},
    'address': {
      'street': 'Street 1',
      'city': 'CityX',
      'parish': 'ParishY',
      'zone': 'ZoneZ',
    },
  };

  Map<String, dynamic> menuJson() => {
    'id': 'menu1',
    'name': 'Lunch Menu',
    'description': 'A variety of dishes',
    'image_url': 'https://image.com/menu.jpg',
    'items': [
      {
        {
          "name": "Grilled Chicken",
          "description": "Tender grilled chicken with herbs",
          "unit_price": 12.5,
          "image_url": [
            "https://example.com/images/chicken1.jpg",
            "https://example.com/images/chicken2.jpg",
          ],
        },
      },
    ],
  };

  group('getRestaurant', () {
    test('returns restaurant when found', () async {
      const id = '123';

      when(mockClient.get(Uri.parse('$baseUrl/restaurants/$id'))).thenAnswer(
        (_) async => http.Response(jsonEncode(restaurantJson(id)), 200),
      );

      final result = await api.getRestaurant(id: id);

      expect(result, isNotNull);
      expect(result!.id, equals(id));
      expect(result.name, equals('Test Restaurant'));
    });

    test('returns null when not found', () async {
      const id = 'notfound';

      when(
        mockClient.get(Uri.parse('$baseUrl/restaurants/$id')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final result = await api.getRestaurant(id: id);

      expect(result, isNull);
    });
  });

  group('getAllRestaurants', () {
    test('returns list when found', () async {
      final data = {
        'restaurants': [restaurantJson('1'), restaurantJson('2')],
      };

      when(
        mockClient.get(Uri.parse('$baseUrl/restaurants/page=1')),
      ).thenAnswer((_) async => http.Response(jsonEncode(data), 200));

      final result = await api.getAllRestaurants(pageNo: 1);

      expect(result.length, equals(2));
    });

    test('returns empty list when not found (non-200)', () async {
      when(
        mockClient.get(Uri.parse('$baseUrl/restaurants/page=1')),
      ).thenAnswer((_) async => http.Response('Error', 404));

      final result = await api.getAllRestaurants(pageNo: 1);

      expect(result, isEmpty);
    });
  });

  group('findRestaurants', () {
    test('returns search results when found', () async {
      final json = {
        'restaurants': [restaurantJson('1')],
      };

      when(
        mockClient.get(Uri.parse('$baseUrl/search/page=1&term=pizza')),
      ).thenAnswer((_) async => http.Response(jsonEncode(json), 200));

      final result = await api.findRestaurants(pageNo: 1, searchTerm: 'pizza');

      expect(result, isNotEmpty);
    });

    test('returns empty list when not found', () async {
      when(
        mockClient.get(Uri.parse('$baseUrl/search/page=1&term=xyz')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final result = await api.findRestaurants(pageNo: 1, searchTerm: 'xyz');

      expect(result, isEmpty);
    });
  });

  group('getRestaurantByLocation', () {
    final location = LocationModel(latitude: 33.6, longitude: 73.1);

    test('returns nearby restaurants when found', () async {
      final json = {
        'restaurants': [restaurantJson('10')],
      };

      final url =
          '$baseUrl/restaurants/page=1&longitude=${location.longitude}&latitude=${location.latitude}';

      when(
        mockClient.get(Uri.parse(url)),
      ).thenAnswer((_) async => http.Response(jsonEncode(json), 200));

      final result = await api.getRestaurantByLocation(
        pageNo: 1,
        location: location,
      );

      expect(result, isNotEmpty);
    });

    test('returns empty list when not found', () async {
      final url =
          '$baseUrl/restaurants/page=1&longitude=${location.longitude}&latitude=${location.latitude}';

      when(
        mockClient.get(Uri.parse(url)),
      ).thenAnswer((_) async => http.Response('Error', 404));

      final result = await api.getRestaurantByLocation(
        pageNo: 1,
        location: location,
      );

      expect(result, isEmpty);
    });
  });

  group('getRestaurantMenu', () {
    const restaurantId = 'abc';

    test('getRestaurantMenu returns menu list when successful', () async {
      // Mock the API response
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            "menu": [
              {
                "id": "menu_item_1",
                "name": "Pizza",
                "description": "Delicious pizza",
                "image_url": ["http://example.com/pizza.jpg"],
                "unit_price": 10.0,
              },
            ],
          }),
          200,
        ),
      );

      // Call the method to be tested
      final result = await api.getRestaurantMenu(restaurantId: 'restaurant_1');

      // Check that the result is a valid menu list
      expect(result, isA<List<MenuModel>>());
      expect(result.length, 1); // Check if there's one item in the list
      expect(result[0].name, 'Pizza');
    });

    test('returns empty list when not found or menu is null', () async {
      final json = {'menu': null};

      final url = '$baseUrl/restaurant/menu/restaurantId=$restaurantId';

      when(
        mockClient.get(Uri.parse(url)),
      ).thenAnswer((_) async => http.Response(jsonEncode(json), 200));

      final result = await api.getRestaurantMenu(restaurantId: restaurantId);

      expect(result, isEmpty);
    });
  });
}
