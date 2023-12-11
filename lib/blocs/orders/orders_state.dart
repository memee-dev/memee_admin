part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {}

abstract class OrdersResponseState extends OrdersState {
  final List<OrderModel> orders;

  OrdersResponseState(this.orders);
}

class OrdersLoading extends OrdersState {
  @override
  List<Object?> get props => [];
}

class OrdersSuccess extends OrdersResponseState {
  OrdersSuccess(List<OrderModel> orders) : super(orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersFailure extends OrdersResponseState {
  final String message;
  OrdersFailure(this.message, List<OrderModel> orders) : super(orders);

  @override
  List<Object?> get props => [message];
}
