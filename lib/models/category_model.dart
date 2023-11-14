class CategoryModel {
  final String id;
  final String name;
  final bool active;

  const CategoryModel({
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
    return map;
  }
}
