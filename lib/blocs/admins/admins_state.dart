part of 'admins_cubit.dart';

abstract class AdminsState extends Equatable {}

abstract class AdminsResponseState extends AdminsState {
  final List<AdminModel> admins;

  AdminsResponseState(this.admins);
}

class AdminsLoading extends AdminsState {
  @override
  List<Object?> get props => [];
}

class AdminsSuccess extends AdminsResponseState {
  AdminsSuccess(List<AdminModel> admins) : super(admins);

  @override
  List<Object?> get props => [admins];
}

class AdminsFailure extends AdminsResponseState {
  final String message;

  AdminsFailure(this.message, List<AdminModel> admins) : super(admins);

  @override
  List<Object?> get props => [message];
}
