class AdminModel {
  final String id;
  String name;
  String email;
  int adminLevel;
  bool active;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.adminLevel,
    required this.active,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      adminLevel: map['adminLevel'],
      active: map['active'],
    );
  }

  String get adminLevell {
    switch (adminLevel) {
      case 0:
        return 'Super Admin';
      case 1:
        return 'Admin';
      case 2:
        return 'Support';
      default:
        return 'Support';
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['adminLevel'] = adminLevel;
    map['active'] = active;
    return map;
  }
}
