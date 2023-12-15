import 'package:intl/intl.dart';

import 'product_model.dart';

class OrderModel {
  final String address;
  final String id;
  final String orderStatus;
  final DateTime orderedTime;
  final List<ItemModel> orderDetails;
  final String paymentId;
  final String paymentStatus;
  final String totalAmount;
  final DateTime updatedTime;
  final String userId;

  OrderModel({
    required this.address,
    required this.id,
    required this.orderStatus,
    required this.orderedTime,
    required this.orderDetails,
    required this.paymentId,
    required this.paymentStatus,
    required this.totalAmount,
    required this.updatedTime,
    required this.userId,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      address: map['address'],
      id: map['id'],
      orderStatus: map['orderStatus'],
      orderedTime:
          DateFormat('MMMM dd, yyyy hh:mm a').parse(map['orderedTime']),
      orderDetails: (map['orders'] as List<dynamic>)
          .map((x) => ItemModel.fromMap(x as Map<String, dynamic>))
          .toList(),
      paymentId: map['paymentId'],
      paymentStatus: map['paymentStatus'],
      totalAmount: map['totalAmount'],
      updatedTime:
          DateFormat('MMMM dd, yyyy hh:mm a').parse(map['updatedTime']),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['orderStatus'] = orderStatus;
    map['orderedTime'] = orderedTime;
    if (orderDetails.isNotEmpty) {
      map['orders'] = List<Map<String, dynamic>>.from(
        orderDetails.map(
          (x) => x.toJson(),
        ),
      );
    }
    map['paymentId'] = paymentId;
    map['paymentStatus'] = paymentStatus;
    map['totalAmount'] = totalAmount;
    map['updatedTime'] = updatedTime;
    map['userId'] = userId;

    return map;
  }
}

class ItemModel {
  final String productId;
  final String image;
  final String name;
  final List<SelectedItemModel> selectedItemDelails;

  ItemModel({
    required this.productId,
    required this.image,
    required this.name,
    required this.selectedItemDelails,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      productId: map['productId'],
      image: map['image'],
      name: map['name'],
      selectedItemDelails: List<SelectedItemModel>.from(
          map['selectedItems'].map((x) => SelectedItemModel.fromMap(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productId'] = productId;
    map['image'] = image;
    map['name'] = name;
    if (selectedItemDelails.isNotEmpty) {
      map['selectedItems'] = List<Map<String, dynamic>>.from(
        selectedItemDelails.map(
          (x) => x.toJson(),
        ),
      );
    }

    return map;
  }
}

class SelectedItemModel {
  final ProductDetailsModel productDetails;
  final int units;

  SelectedItemModel({
    required this.productDetails,
    required this.units,
  });

  factory SelectedItemModel.fromMap(Map<String, dynamic> map) {
    return SelectedItemModel(
      units: map['units'],
      productDetails: ProductDetailsModel.fromMap(map['productDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['units'] = units;
    map['productDetails'] = productDetails.toJson();
    return map;
  }
}
