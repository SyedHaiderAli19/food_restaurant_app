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
      unitPrice: _parseUnitPrice(json['unitPrice']),
      imageUrl: _parseImageUrls(json['imageUrls']),
    );
  }

  static double _parseUnitPrice(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return 0.0;
  }

  static List<String> _parseImageUrls(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }
}
