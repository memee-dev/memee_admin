class AdminModel {
  String docId;
  String id;
  String name;
  String email;
  bool superAdmin;
  num adminLevel;

  AdminModel({
    required this.docId,
    required this.id,
    required this.name,
    required this.email,
    required this.superAdmin,
    required this.adminLevel,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      docId: map['docId'],
      id: map['id'],
      name: map['name'],
      email: map['email'],
      superAdmin: map['superAdmin'],
      adminLevel: map['adminLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['docId'] = docId;
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['superAdmin'] = superAdmin;
    map['adminLevel'] = adminLevel;
    return map;
  }
}
