import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../core/shared/app_logger.dart';
import '../../models/admin_model.dart';

part 'admins_state.dart';

class AdminCubit extends Cubit<AdminsState> {
  final FirebaseFirestore db;
  final FirebaseAuth auth;
  final collectionName = AppFireStoreCollection.admins;
  List<AdminModel> admins = [];
  AdminCubit(this.auth, this.db) : super(AdminsEmpty());

  void refresh() {
    emit(AdminsLoading());
    emit(AdminsSuccess(admins));
  }

  int adminsCount = 0;
  int pageSize = 20;
  int pageNo = 1;
  DocumentSnapshot? lastDocument;

  Future<void> fetchAdmins({bool clear = false}) async {
    try {
      final countSnap = await db.collection(collectionName).count().get();
      adminsCount = countSnap.count;

      if (adminsCount > admins.length) {
        emit(AdminsLoading());
        QuerySnapshot<Map<String, dynamic>> adminDocs;
        if (clear) {
          admins.clear();
          adminDocs = await db.collection(collectionName).limit(pageSize).get();
        } else {
          adminDocs = await db
              .collection(collectionName)
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get();
        }

        final docs = adminDocs.docs;
        lastDocument = docs.last;

        List<AdminModel> fetched10Admins = [];
        for (var doc in docs) {
          final data = doc.data();
          data['id'] = doc.id;
          fetched10Admins.add(AdminModel.fromMap(data));
        }

        admins.addAll(fetched10Admins);
        emit(AdminsSuccess(fetched10Admins));
      }
    } catch (e) {
      emit(AdminsFailure(
        e.toString(),
        admins,
      ));
      console.e('FETCH ADMINS', error: e);
    }
  }

  // Future<void> fetchAdmins() async {
  //   List<AdminModel> admins = [];
  //   emit(AdminsLoading());
  //   try {
  //     final adminDoc = await db.collection(collectionName).get();

  //     final docs = adminDoc.docs;

  //     for (var doc in docs) {
  //       final data = doc.data();
  //       data['id'] = doc.id;
  //       admins.add(AdminModel.fromMap(data));
  //     }

  //     emit(AdminsSuccess(admins));
  //   } catch (e) {
  //     emit(AdminsFailure(
  //       e.toString(),
  //       admins,
  //     ));
  //     console.e('FETCH Admins', error: e);
  //   }
  // }

  Future<void> addAdmin({
    required String name,
    required String email,
    required int adminLevel,
    required bool status,
  }) async {
    try {
      emit(AdminsLoading());
      final adminCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: '123456', //TODO: please genrate random password and sendEMail
      );

      final user = adminCredential.user;
      if (user != null) {
        final adminCollection = db.collection(collectionName);
        final _admin = AdminModel(
          id: user.uid,
          name: name,
          email: email,
          adminLevel: adminLevel,
          active: status,
        );
        await adminCollection.doc(_admin.id).set(_admin.toJson());
        admins.add(_admin);
        emit(AdminsSuccess(admins));
      }
    } catch (e) {
      emit(AdminsFailure(
        e.toString(),
        admins,
      ));
      console.e('ADD A ADMIN', error: e);
    }
  }

  Future<void> deleteAdmin(AdminModel admin) async {
    List<AdminModel> admins = getLocalAdmins();
    try {
      admins.remove(admin);
      await db.collection(collectionName).doc(admin.id).delete();
      emit(AdminsSuccess(admins));
    } catch (e) {
      emit(AdminsFailure(
        e.toString(),
        admins,
      ));
      console.e('DELETE ADMIN', error: e);
    }
  }

  Future<void> updateAdmin(AdminModel admin) async {
    List<AdminModel> admins = getLocalAdmins();
    try {
      await db.collection(collectionName).doc(admin.id).set(admin.toJson());
      int index = admins.indexWhere((element) => admin.id == element.id);
      admins[index] = admin;
      emit(AdminsSuccess(admins));
    } catch (e) {
      emit(AdminsFailure(
        e.toString(),
        const [],
      ));
      console.e('UPDATE ADMIN', error: e);
    }
  }

  List<AdminModel> getLocalAdmins() {
    List<AdminModel> admins = [];
    if (state is AdminsSuccess) {
      admins.addAll((state as AdminsSuccess).admins);
    } else if (state is AdminsFailure) {
      admins.addAll((state as AdminsFailure).admins);
    }
    return admins;
  }
}
