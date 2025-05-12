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

  static fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      displayImageUrl: json['image_url'],
      items:
          json['items'] !=
                  null //if items not empty return another map of menu items under items
              ? json['items'].map<MenuItemModel>(
                (Map<String, dynamic> item) => MenuItemModel(
                  name: item['name'],
                  description: item['description'],
                  imageUrl: item['image_url'],
                  unitPrice: item['unit_price'],
                ),
              )
              : [], //empty list incase of no items,
    );
  }
}
