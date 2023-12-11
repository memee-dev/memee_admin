class OrderModel {
  final String id;
  String userId;
  String userName;
  String productId;
  String productName;
  String categoryId;
  String categoryName;
  String paymentId;
  String paymentStatus;
  String orderStatus;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    required this.paymentId,
    required this.paymentStatus,
    required this.orderStatus,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      productId: map['productId'],
      productName: map['productName'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      paymentId: map['paymentId'],
      paymentStatus: map['paymentStatus'],
      orderStatus: map['orderStatus'],
    );
  }

  Map<String, dynamic> toJson({bool addId = false}) {
    final map = <String, dynamic>{};
    if (addId) map['id'] = id;
    map['userId'] = userId;
    map['userName'] = userName;
    map['productId'] = productId;
    map['productName'] = productName;
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    map['paymentId'] = paymentId;
    map['paymentStatus'] = paymentStatus;
    map['orderStatus'] = orderStatus;
    return map;
  }
}

List<OrderModel> fakeOrders = [
  OrderModel(
    id: 'P001',
    userId: 'U001',
    userName: 'Zakariya',
    productId: 'P001',
    productName: 'Chicken leg',
    categoryId: 'C001',
    categoryName: 'Chicken',
    paymentId: 'P001',
    paymentStatus: 'Processing',
    orderStatus: 'Awaiting',
  ),
  OrderModel(
    id: 'P002',
    userId: 'U002',
    userName: 'yousuf',
    productId: 'P002',
    productName: 'Vanjiram',
    categoryId: 'C002',
    categoryName: 'Fish',
    paymentId: 'P002',
    paymentStatus: 'Failed',
    orderStatus: 'Cancelled',
  ),
];
