import 'package:equatable/equatable.dart';
import 'package:restaurant/restaurant.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
}

class InitialState extends RestaurantState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

class LoadingState extends RestaurantState {
  const LoadingState();
  @override
  List<Object?> get props => [];
}

class PageLoadedState extends RestaurantState {
  List<RestaurantModel> get restaurants => page.restaurants;
  final PageModel page;
  int? get nextPage => page.isLast ? null : page.currentPage + 1;

  const PageLoadedState({required this.page});

  @override
  List<Object?> get props => [page];
}

class RestaurantLoadedState extends RestaurantState {
  final RestaurantModel restaurant;

  const RestaurantLoadedState({required this.restaurant});
  @override
  List<Object?> get props => [restaurant];
}

class MenuLoadedState extends RestaurantState {
  final List<MenuModel> menus;
  const MenuLoadedState({required this.menus});

  @override
  List<Object?> get props => [menus];
}

class ErrorState extends RestaurantState {
  final String errorMessage;

  const ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
