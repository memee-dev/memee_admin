import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/models/user_model.dart';

part 'users_state.dart';

class UserCubit extends Cubit<UsersState> {
  final FirebaseFirestore db;

  UserCubit(this.db) : super(UsersLoading());

  Future<void> fetchUsers() async {
    emit(UsersLoading());
    try {
      final userDoc = await db.collection(AppFireStoreCollection.users).get();
      List<UserModel> users = [];
      final docs = userDoc.docs;

      for (var doc in docs) {
        users.add(UserModel.fromJson(doc.data()));
      }

      emit(UsersSuccess(users));
    } catch (e) {
      emit(UsersFailure(e.toString()));
    }
  }

  Future<void> addUsers(List<UserModel> users) async {
    emit(UsersLoading());
    final userCollection = db.collection(AppFireStoreCollection.users);
    for (var user in users) {
      await userCollection.doc(user.phoneNumber).set(user.toJson());
    }

    emit(UsersSuccess(users));
  }

  //edit category
  Future<void> updateUser(UserModel user) async {
    await db
        .collection(AppFireStoreCollection.admins)
        .doc(user.phoneNumber)
        .set(user.toJson());
  }
}
