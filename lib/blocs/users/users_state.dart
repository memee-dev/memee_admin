part of 'users_cubit.dart';

abstract class UsersState extends Equatable {}

abstract class UsersResponseState extends UsersState {
  final List<UserModel> users;

  UsersResponseState(this.users);
}

class UsersLoading extends UsersState {
  @override
  List<Object?> get props => [];
}

class UsersSuccess extends UsersResponseState {
  UsersSuccess(List<UserModel> users) : super(users);

  @override
  List<Object?> get props => [users];
}

class UsersFailure extends UsersResponseState {
  final String message;

  UsersFailure(this.message, List<UserModel> users) : super(users);

  @override
  List<Object?> get props => [message];
}
