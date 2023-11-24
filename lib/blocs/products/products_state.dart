part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {}

abstract class ProductsResponseState extends ProductsState {
  final List<ProductModel> products;

  ProductsResponseState(this.products);
}

class ProductsLoading extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsSuccess extends ProductsResponseState {
  ProductsSuccess(List<ProductModel> products) : super(products);

  @override
  List<Object?> get props => [products];
}

class ProductsFailure extends ProductsResponseState {
  final String message;

  ProductsFailure(this.message, List<ProductModel> products) : super(products);

  @override
  List<Object?> get props => [message];
}
