class CategoryModel {
  final String id;
  String name;
  bool active;

  CategoryModel({
    required this.id,
    required this.name,
    required this.active,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      active: map['active'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['active'] = active;
    return map;
  }
}
