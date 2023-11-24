class ProductModel {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final List<String>? images;
  final List<ProductDetailsModel> productDetails;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.images,
    required this.productDetails,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      description: map['description'],
      images: map['images'],
      productDetails: map['productDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['categoryId'] = name;
    map['categoryName'] = name;
    map['description'] = name;
    if (images != null && images!.isNotEmpty) {
      map['images'] = List<String>.from(images!.map((x) => x));
    }
    if (productDetails.isNotEmpty) {
      map['productDetails'] = List<Map<String, dynamic>>.from(productDetails.map((x) => x.toJson()));
    }
    return map;
  }
}

class ProductDetailsModel {
  final double price;
  final double discountedPrice;
  final int qty;

  ProductDetailsModel({
    required this.price,
    required this.discountedPrice,
    required this.qty,
  });

  factory ProductDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailsModel(
      price: map['price'],
      discountedPrice: map['discountedPrice'],
      qty: map['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['price'] = price;
    map['discountedPrice'] = discountedPrice;
    map['qty'] = qty;
    return map;
  }
}
