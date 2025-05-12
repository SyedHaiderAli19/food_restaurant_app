class MenuItemModel {
  final String name;
  final String description;
  final double unitPrice;
  final List<String> imageUrl;

  MenuItemModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.unitPrice,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unitPrice: (json['unit_price'] as num).toDouble(),
      imageUrl: List<String>.from(json['image_url'] ?? []),
    );
  }
}
