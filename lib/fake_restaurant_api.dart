import 'package:faker/faker.dart' as ff;
import 'package:restaurant/restaurant.dart';

class FakeRestaurantApi implements IRestaurantApi {
  late List<RestaurantModel?> _restaurants;
  final List<MenuModel> _restaurantMenus = [];

  FakeRestaurantApi(int numberOfRestaurants) {
    final faker = ff.Faker();
    _restaurants = List.generate(
      numberOfRestaurants,
      (index) => RestaurantModel(
        id: index.toString(),
        name: faker.company.name(),
        type: faker.food.cuisine(),
        displayImageUrl: faker.internet.httpUrl(),
        address: AddressModel(
          zone: "",
          street: faker.address.streetName(),
          city: faker.address.city(),
          parish: faker.address.country(),
        ),
        location: LocationModel(
          longitude: faker.randomGenerator.integer(5).toDouble(),
          latitude: faker.randomGenerator.integer(5).toDouble(),
        ),
      ),
    );

    _restaurants.forEach((restaurant) {
      var menus = List.generate(
        faker.randomGenerator.integer(5),
        (index) => MenuModel(
          id: restaurant!.id,
          displayImageUrl: "",
          name: faker.food.dish(),
          description: faker.lorem.sentences(2).join(),
          items: List.generate(
            faker.randomGenerator.integer(15),
            (_) => MenuItemModel(
              imageUrl: [],
              name: faker.food.dish(),
              description: faker.lorem.sentence(),
              unitPrice:
                  faker.randomGenerator.integer(5000, min: 500).toDouble(),
            ),
          ),
        ),
      );
      _restaurantMenus.addAll(menus);
    });
  }

  @override
  Future<PageModel?> findRestaurants({
    required int limit,
    required int pageNo,
    required String searchTerm,
  }) async {
    final bool Function(RestaurantModel?)? filter =
        searchTerm.isEmpty
            ? (RestaurantModel? res) => res!.name.toLowerCase().contains(
              searchTerm.toLowerCase().trim(),
            )
            : null;
    await Future.delayed(Duration(seconds: 2));

    return _paginatedRestaurants(pageNo, limit, filter: filter);
  }

  @override
  Future<PageModel?> getAllRestaurants({
    required int limit,
    required int pageNo,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return _paginatedRestaurants(pageNo, limit);
  }

  @override
  Future<RestaurantModel?> getRestaurant({required String id}) async {
    return _restaurants.singleWhere(
      (restaurant) => restaurant!.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<List<MenuModel>> getRestaurantMenu({
    required String restaurantId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return _restaurantMenus.where((menu) => menu.id == restaurantId).toList();
  }

  @override
  Future<PageModel?> getRestaurantByLocation({
    required int limit,
    required LocationModel location,
    required int pageNo,
  }) async {
    final filter =
        location != null
            ? (RestaurantModel? res) => res!.location == location
            : null;
    return _paginatedRestaurants(pageNo, limit, filter: filter);
  }

  PageModel _paginatedRestaurants(
    int page,
    int pageSize, {
    bool Function(RestaurantModel?)? filter,
  }) {
    final int offset = (page - 1) * pageSize;
    final restaurants =
        filter == null ? _restaurants : _restaurants.where(filter).toList();
    final totalPages = (restaurants.length / pageSize).ceil();

    final result = restaurants.skip(offset).take(pageSize).toList();

    return PageModel(
      currentPage: page,
      totalPages: totalPages,
      restaurants: result as List<RestaurantModel>,
    );
  }
}
