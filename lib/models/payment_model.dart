class PaymentModel {
  final String id;
  String userName;
  String orderId;
  String paymentStatus;

  String dlName;
  String amount;

  PaymentModel({
    required this.id,
    required this.userName,
    required this.orderId,
    required this.paymentStatus,
    required this.dlName,
    required this.amount,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      userName: map['userName'],
      orderId: map['orderId'],
      paymentStatus: map['paymentStatus'],
      dlName: map['dlName'],
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toJson({bool addId = false}) {
    final map = <String, dynamic>{};
    if (addId) map['id'] = id;
    map['userName'] = userName;
    map['orderId'] = orderId;
    map['paymentStatus'] = paymentStatus;
    map['dlName'] = dlName;
    map['amount'] = amount;
    return map;
  }
}

List<PaymentModel> fakePayments = [
  PaymentModel(
    id: 'P001',
    userName: 'Zakariya',
    orderId: 'O001',
    paymentStatus: 'Failed',
    dlName: 'ashok',
    amount: '200',
  ),
  PaymentModel(
    id: 'P002',
    userName: 'Yousuf',
    orderId: 'O002',
    paymentStatus: 'Processing',
    dlName: 'dilip',
    amount: '1000',
  ),
];
