import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  String name;
  String image;
  bool active;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.active = true,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      active: map['active'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toJson({bool addId = false}) {
    final map = <String, dynamic>{};
    if (addId) map['id'] = id;
    map['name'] = name;
    map['active'] = active;
    map['image'] = image;
    return map;
  }

  @override
  String toString() => name;

  @override
  List<Object?> get props => [id, name, image, active];
}
