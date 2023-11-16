part of 'users_cubit.dart';

abstract class UsersState extends Equatable {}

class UsersLoading extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersSuccess extends UsersState {
  final List<UserModel> users;

  UsersSuccess(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersFailure extends UsersState {
  final String message;

  UsersFailure(this.message);

  @override
  List<Object?> get props => [message];
}
