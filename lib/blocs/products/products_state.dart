part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {}

class ProductsLoading extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsSuccess extends ProductsState {
  final List<ProductModel> products;

  ProductsSuccess(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsFailure extends ProductsState {
  final String message;

  ProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
