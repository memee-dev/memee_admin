
class UserModel {
    UserModel({
        required this.address,
        required this.id,
        required this.phoneNumber,
        required this.verified,
        required this.active,
        required this.userName,
        required this.email,
    });

    List<AddressModel> address;
    String phoneNumber;
    String id;
    bool verified;
    bool active;
    String userName;
    String email;

    factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        address: List<AddressModel>.from(json["address"].map((x) => AddressModel.fromJson(x))),
        phoneNumber: json["phoneNumber"],
        verified: json["verified"],
        id: json["id"],
        active: json["active"],
        userName: json["userName"],
        email: json["email"],
    );
AddressModel defaultAddress (){
  return address.where((element) => element.defaultt).toList()[0];
}

    Map<String, dynamic> toJson() => {
        "address": List<AddressModel>.from(address.map((x) => x.toJson())),
        "phoneNumber": phoneNumber,
        "verified": verified,
        "id": id,
        "active": active,
        "userName": userName,
        "email": email,
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

    factory AddressModel.fromJson(Map<dynamic, dynamic> json) => AddressModel(
        area: json["area"],
        pincode: json["pincode"],
        no: json["no"],
        defaultt: json["default"],
        city: json["city"],
        street: json["street"],
        landmark: json["landmark"],
        type: json["type"],
    );

    Map<dynamic, dynamic> toJson() => {
        "area": area,
        "pincode": pincode,
        "no": no,
        "default": defaultt,
        "city": city,
        "street": street,
        "landmark": landmark,
        "type": type,
    };

}
