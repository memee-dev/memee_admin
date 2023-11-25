import 'package:memee_admin/models/category_model.dart';

class ProductModel {
  final String id;
  final String name;
  final CategoryModel category;
  final String description;
  bool active;
  final List<String>? images;
  final List<ProductDetailsModel> productDetails;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.images,
    required this.productDetails,
    this.active = true,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      category: CategoryModel.fromMap(map['category']),
      description: map['description'],
      images: List<String>.from(map['images'].map((x) => x)),
      productDetails: List<ProductDetailsModel>.from(
          map['productDetails'].map((x) => ProductDetailsModel.fromMap(x))),
      active: map['active'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['category'] = category.toJson(addId: true);
    map['description'] = description;
    map['active'] = active;
    if (images != null && images!.isNotEmpty) {
      map['images'] = List<String>.from(images!.map((x) => x));
    }
    if (productDetails.isNotEmpty) {
      map['productDetails'] = List<Map<String, dynamic>>.from(
        productDetails.map(
          (x) => x.toJson(),
        ),
      );
    }
    return map;
  }
}

enum ProductType {
  kg,
  piece,
}

class ProductDetailsModel {
  final double price;
  final double discountedPrice;
  final int qty;
  final ProductType type;

  ProductDetailsModel({
    required this.price,
    required this.discountedPrice,
    required this.qty,
    required this.type,
  });

  factory ProductDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailsModel(
      price: map['price'],
      discountedPrice: map['discountedPrice'],
      qty: map['qty'],
      type: _parseProductType(map['type']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['price'] = price;
    map['discountedPrice'] = discountedPrice;
    map['qty'] = qty;
    map['type'] = type.name;
    return map;
  }

  static ProductType _parseProductType(String value) {
    if (value == 'kg') {
      return ProductType.kg;
    } else if (value == 'piece') {
      return ProductType.piece;
    } else {
      throw ArgumentError('Invalid product type');
    }
  }
}
