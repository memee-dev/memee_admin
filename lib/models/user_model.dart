class UserModel {
  UserModel({
    required this.address,
    required this.id,
    required this.phoneNumber,
    this.verified = false,
    this.active = true,
    required this.userName,
    required this.email,
  });

  List<AddressModel> address;
  String phoneNumber;
  final String id;
  bool verified;
  bool active;
  String userName;
  String email;

  factory UserModel.fromMap(Map<dynamic, dynamic> map) => UserModel(
        address: List<AddressModel>.from(
            map['address'].map((x) => AddressModel.fromMap(x))),
        phoneNumber: map['phoneNumber'],
        verified: map['verified'],
        id: map['id'],
        active: map['active'],
        userName: map['userName'],
        email: map['email'],
      );
  AddressModel defaultAddress() {
    return address.where((element) => element.defaultt).toList()[0];
  }

  Map<String, dynamic> toJson() => {
        'address':
            List<Map<String, dynamic>>.from(address.map((x) => x.toJson())),
        'phoneNumber': phoneNumber,
        'verified': verified,
        'id': id,
        'active': active,
        'userName': userName,
        'email': email,
      };
}

class AddressModel {
  AddressModel({
    required this.area,
    required this.pincode,
    required this.no,
    required this.defaultt,
    required this.city,
    required this.street,
    required this.landmark,
    required this.type,
  });

  String area;
  String pincode;
  String no;
  bool defaultt;
  String city;
  String street;
  String landmark;
  String type;

  factory AddressModel.fromMap(Map<dynamic, dynamic> map) => AddressModel(
        area: map['area'],
        pincode: map['pincode'],
        no: map['no'],
        defaultt: map['default'],
        city: map['city'],
        street: map['street'],
        landmark: map['landmark'],
        type: map['type'],
      );

  Map<String, dynamic> toJson() => {
        'area': area,
        'pincode': pincode,
        'no': no,
        'default': defaultt,
        'city': city,
        'street': street,
        'landmark': landmark,
        'type': type,
      };

  @override
  String toString() => '$type, $no, $city';
}
