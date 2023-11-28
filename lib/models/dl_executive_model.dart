class DlExecutiveModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String? dlUrl;
  String dlNumber;
  String? aadhar;
  bool active;
  bool alloted;

  DlExecutiveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.dlUrl,
    required this.dlNumber,
    required this.aadhar,
    this.active = true,
    this.alloted = false,
  });

  factory DlExecutiveModel.fromMap(Map<String, dynamic> map) {
    return DlExecutiveModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dlUrl: map['dlUrl'],
      dlNumber: map['dlNo'],
      aadhar: map['aadhar'],
      active: map['active'],
      alloted: map['alloted'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['dlUrl'] = dlUrl;
    map['dlNo'] = dlNumber;
    map['aadhar'] = aadhar;
    map['active'] = active;
    map['alloted'] = alloted;
    return map;
  }
}
