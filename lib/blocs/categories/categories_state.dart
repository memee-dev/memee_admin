part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {}

abstract class CategoriesResponseState extends CategoriesState {
  final Set<CategoryModel> categories;

  CategoriesResponseState(this.categories);
}

class CategoriesLoading extends CategoriesState {
  @override
  List<Object?> get props => [];
}

class CategoriesSuccess extends CategoriesResponseState {
  CategoriesSuccess(Set<CategoryModel> categories) : super(categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesFailure extends CategoriesResponseState {
  final String message;
  CategoriesFailure(this.message, Set<CategoryModel> categories)
      : super(categories);

  @override
  List<Object?> get props => [message];
}
