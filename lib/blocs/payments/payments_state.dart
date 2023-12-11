part of 'payments_cubit.dart';

abstract class PaymentsState extends Equatable {}

abstract class PaymentsResponseState extends PaymentsState {
  final List<PaymentModel> payments;

  PaymentsResponseState(this.payments);
}

class PaymentsLoading extends PaymentsState {
  @override
  List<Object?> get props => [];
}

class PaymentsSuccess extends PaymentsResponseState {
  PaymentsSuccess(List<PaymentModel> payments) : super(payments);

  @override
  List<Object?> get props => [payments];
}

class PaymentsFailure extends PaymentsResponseState {
  final String message;
  PaymentsFailure(this.message, List<PaymentModel> payments) : super(payments);

  @override
  List<Object?> get props => [message];
}
