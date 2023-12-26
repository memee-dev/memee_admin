import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/core/shared/app_logger.dart';
import 'package:memee_admin/models/user_model.dart';

part 'users_state.dart';

class UserCubit extends Cubit<UsersState> {
  final FirebaseFirestore db;

  final collectionName = AppFireStoreCollection.users;

  List<UserModel> users = [];

  UserCubit(this.db) : super(UsersEmpty());
  void refresh() {
    emit(UsersLoading());
    emit(UsersSuccess(users));
  }
  int usersCount = 0;
  int pageSize = 20;
  int pageNo = 1;
  DocumentSnapshot? lastDocument;

  Future<void> fetchUsers({bool clear = false}) async {
    try {
      final countSnap = await db.collection(collectionName).count().get();
      usersCount = countSnap.count;

      if (usersCount > users.length) {
        emit(UsersLoading());
        QuerySnapshot<Map<String, dynamic>> userDocs;
        if (clear) {
          users.clear();
          userDocs =
              await db.collection(collectionName).limit(pageSize).get();
        } else {
          userDocs = await db
              .collection(collectionName)
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get();
        }

        final docs = userDocs.docs;
        lastDocument = docs.last;

        List<UserModel> fetched10Users = [];
        for (var doc in docs) {
          final data = doc.data();
          data['id'] = doc.id;
          fetched10Users.add(UserModel.fromMap(data));
        }

        users.addAll(fetched10Users);
        emit(UsersSuccess(fetched10Users));
      }
    } catch (e) {
      emit(UsersFailure(
        e.toString(),
        users,
      ));
      console.e('FETCH USERS', error: e);
    }
  }

  // Future<void> fetchUsers() async {
  //   List<UserModel> users = [];
  //   emit(UsersLoading());
  //   try {
  //     final usersDoc = await db.collection(collectionName).get();
  //     final docs = usersDoc.docs;

  //     for (var doc in docs) {
  //       final data = doc.data();
  //       data['id'] = doc.id;
  //       users.add(UserModel.fromMap(data));
  //     }
  //     emit(UsersSuccess(users));
  //   } catch (e) {
  //     emit(UsersFailure(
  //       e.toString(),
  //       users,
  //     ));
  //     console.e('FETCH Users', error: e);
  //   }
  // }

  Future<void> addUser(UserModel user) async {
    List<UserModel> users = getLocalUsers();
    try {
      final ref = db.collection(collectionName);
      int lastNumber = 1;

      late String sequentialDocId;
      if (users.isEmpty) {
        sequentialDocId = lastNumber.toString().padLeft(3, '0');
      } else {
        lastNumber = int.parse(users.last.id.substring(1));
        sequentialDocId = (lastNumber + 1).toString().padLeft(3, '0');
      }

      sequentialDocId = 'u$sequentialDocId';
      ref.doc(sequentialDocId).set(user.toJson());
      users.add(user);
      emit(UsersSuccess(users));
    } catch (e) {
      emit(UsersFailure(
        e.toString(),
        users,
      ));
      console.e('ADD a User', error: e);
    }
  }

  Future<void> addUsers(
    List<UserModel> users, {
    bool clearAll = false,
  }) async {
    emit(UsersLoading());
    try {
      final userCollection = db.collection(collectionName);
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
      emit(UsersFailure(
        e.toString(),
        const [],
      ));
      console.e('ADD All Users', error: e);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await db.collection(collectionName).doc(user.id).set(user.toJson());
    } catch (e) {
      console.e('UPDATE a User', error: e);
    }
  }

  Future<void> deleteUser(UserModel user) async {
    List<UserModel> users = getLocalUsers();
    try {
      users.remove(user);
      await db.collection(collectionName).doc(user.id).delete();
      emit(UsersSuccess(users));
    } catch (e) {
      emit(UsersFailure(
        e.toString(),
        users,
      ));
      console.e('DELETE User', error: e);
    }
  }

  Future<void> deleteAllUser() async {
    try {
      final usersCollection = await db.collection(collectionName).get();
      final userDocs = usersCollection.docs;

      final batch = db.batch();
      for (var doc in userDocs) {
        batch.delete(doc.reference);
      }
      batch.commit();
    } catch (e) {
      console.e('DELETE All Users', error: e);
    }
  }

  List<UserModel> getLocalUsers() {
    List<UserModel> dlExecutives = [];
    if (state is UsersSuccess) {
      dlExecutives.addAll((state as UsersSuccess).users);
    } else if (state is UsersFailure) {
      dlExecutives.addAll((state as UsersFailure).users);
    }
    return dlExecutives;
  }
}
