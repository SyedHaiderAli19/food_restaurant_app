import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:restaurant/src/api/restaurant_api.dart';

class HttpClient extends MockClient implements http.Client {
  HttpClient(super.fn);
}

void main() {
  RestaurantApi sut;
  http.Client client;

  setUp(() {});
  client = http.Client();
  sut = RestaurantApi(baseUrl: "baseUrl", httpClient: client);

  group('getAllRestaurants', () {
    test('returns empty list when no restaurants are found', () async {

      //arrange
      when(client.get(any))
    });
  });
}
