class ProductModel {
  final String id;
  final String name;
  final String description;
  // final double amount;
  // final String image;
  // final String category;
  // final String kg;

  const ProductModel( {
    required this.id,
    required this.name,
    required this.description,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    return map;
  }
}

const List<ProductModel> products = [
  ProductModel(id: '1', name: 'Product 1', description: 'Description 1'),
  ProductModel(id: '2', name: 'Product 2', description: 'Description 2'),
];
