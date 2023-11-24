class CategoryModel {
  final String id;
  String name;
  bool active;

  CategoryModel({
    required this.id,
    required this.name,
    this.active = true,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      active: map['active'],
    );
  }

  Map<String, dynamic> toJson({bool addId = false}) {
    final map = <String, dynamic>{};
    if (addId) map['id'] = id;
    map['name'] = name;
    map['active'] = active;
    return map;
  }

  @override
  String toString() => name;
}
