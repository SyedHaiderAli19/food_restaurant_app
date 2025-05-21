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

  static MenuModel fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      displayImageUrl: json['imageUrl']?.toString() ?? '',
      items:
          (json['items'] as List<dynamic>? ?? []).map<MenuItemModel>((item) {
            return MenuItemModel(
              name: item['name']?.toString() ?? '',
              description: item['description']?.toString() ?? '',
              imageUrl:
                  (item['imageUrls'] as List<dynamic>? ?? [])
                      .map((e) => e.toString())
                      .toList(),
              unitPrice:
                  (item['unitPrice'] is num)
                      ? (item['unitPrice'] as num).toDouble()
                      : 0.0,
            );
          }).toList(),
    );
  }
}
