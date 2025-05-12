import 'package:restaurant/src/domain/menu_item_model.dart';

class MenuModel {
  final String id;
  final String name;
  final String description;
  final String displayImageUrl;
  final List<MenuItemModel> items;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.displayImageUrl,
    required this.items,
  });
}
