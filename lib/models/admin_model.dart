class AdminModel {
  String id;
  String name;
  String email;
  bool superAdmin;
  num adminLevel;
  bool active;

  AdminModel({
  
    required this.id,
    required this.name,
    required this.email,
    required this.superAdmin,
    required this.adminLevel,
    required this.active,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      superAdmin: map['superAdmin'],
      adminLevel: map['adminLevel'],
      active: map['active'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['superAdmin'] = superAdmin;
    map['adminLevel'] = adminLevel;
    map['active'] = active;
    return map;
  }
}
