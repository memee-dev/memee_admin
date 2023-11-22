part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {}

class CategoriesLoading extends CategoriesState {
  @override
  List<Object?> get props => [];
}

class CategoriesSuccess extends CategoriesState {
  final List<CategoryModel> categories;

  CategoriesSuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesFailure extends CategoriesState {
  final String message;

  CategoriesFailure(this.message);

  @override
  List<Object?> get props => [message];
}


