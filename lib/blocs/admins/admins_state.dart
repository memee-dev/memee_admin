part of 'admins_cubit.dart';

abstract class AdminsState extends Equatable {}

class AdminsLoading extends AdminsState {
  @override
  List<Object?> get props => [];
}

class AdminsSuccess extends AdminsState {
  final List<AdminModel> admins;

  AdminsSuccess(this.admins);

  @override
  List<Object?> get props => [admins];
}

class AdminsFailure extends AdminsState {
  final String message;

  AdminsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
