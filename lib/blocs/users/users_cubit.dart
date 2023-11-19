import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/core/shared/app_logger.dart';
import 'package:memee_admin/models/user_model.dart';

import '../../ui/__shared/enums/crud_enum.dart';

part 'users_state.dart';

class UserCubit extends Cubit<UsersState> {
  final FirebaseFirestore db;

  UserCubit(this.db) : super(UsersLoading());

  Future<void> fetchUsers() async {
    emit(UsersLoading());
    try {
      final usersCollection =
          await db.collection(AppFireStoreCollection.users).get();
      final userDocs = usersCollection.docs;

      List<UserModel> users = [];
      for (var doc in userDocs) {
        final data = doc.data();
        data['id'] = doc.id;
        users.add(UserModel.fromJson(data));
      }
      emit(UsersSuccess(users));
    } catch (e) {
      log.e('FETCH Users', error: e);
      emit(UsersFailure(e.toString()));
    }
  }

  Future<void> addUsers(
    List<UserModel> users, {
    bool clearAll = false,
  }) async {
    emit(UsersLoading());
    try {
      final userCollection = db.collection(AppFireStoreCollection.users);
      if (clearAll) {
        deleteAllUser();
      }
      final batch = db.batch();
      for (var user in users) {
        batch.set(userCollection.doc(), user.toJson());
      }
      batch.commit();

      emit(UsersSuccess(users));
    } catch (e) {
      log.e('ADD All Users', error: e);
      emit(UsersFailure(e.toString()));
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await db.collection(AppFireStoreCollection.users).add(user.toJson());
      crudLocally(user, CRUD.create);
    } catch (e) {
      log.e('ADD a User', error: e);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await db
          .collection(AppFireStoreCollection.users)
          .doc(user.id)
          .set(user.toJson());
      crudLocally(user, CRUD.update);
    } catch (e) {
      log.e('UPDATE a User', error: e);
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await db.collection(AppFireStoreCollection.users).doc(user.id).delete();
      crudLocally(user, CRUD.delete);
    } catch (e) {
      log.e('DELETE a User', error: e);
    }
  }

  Future<void> deleteAllUser() async {
    try {
      final usersCollection =
          await db.collection(AppFireStoreCollection.users).get();
      final userDocs = usersCollection.docs;

      final batch = db.batch();
      for (var doc in userDocs) {
        batch.delete(doc.reference);
      }
      batch.commit();
    } catch (e) {
      log.e('DELETE All Users', error: e);
    }
  }

  void crudLocally(UserModel user, CRUD crud) {
    try {
      if (state is UsersSuccess) {
        final users = (state as UsersSuccess).users;
        if (crud == CRUD.create) {
          users.add(user);
          emit(UsersLoading());
          emit(UsersSuccess(users));
        } else {
          int index = (state as UsersSuccess)
              .users
              .indexWhere((existingUser) => existingUser.id == user.id);

          if (index != -1) {
            if (crud == CRUD.update) {
              users[index] = user;
            } else if (crud == CRUD.delete) {
              users.removeAt(index);
            }
            emit(UsersLoading());
            emit(UsersSuccess(users));
          } else {
            log.e('updateUserLocally', error: 'Not found');
          }
        }
      }
    } catch (e) {
      log.e('updateUserLocally', error: e);
    }
  }
}
