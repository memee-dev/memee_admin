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

  AdminCubit(this.auth, this.db) : super(AdminsLoading());

  Future<void> fetchAdmins() async {
    List<AdminModel> admins = [];
    emit(AdminsLoading());
    try {
      final adminDoc = await db.collection(collectionName).get();

      final docs = adminDoc.docs;

      for (var doc in docs) {
        admins.add(AdminModel.fromMap(doc.data()));
      }

      emit(AdminsSuccess(admins));
    } catch (e) {
      emit(AdminsFailure(
        e.toString(),
        admins,
      ));
      log.e('FETCH Admins', error: e);
    }
  }

  Future<void> addAdmin(AdminModel admin) async {
    List<AdminModel> admins = getLocalAdmins();
    try {
      final adminCredential = await auth.createUserWithEmailAndPassword(
        email: admin.email,
        password: '123456', //TODO: please genrate random password and sendEMail
      );

      final user = adminCredential.user;
      if (user != null) {
        final adminCollection = db.collection(collectionName);
        await adminCollection.doc(user.uid).set(admin.toJson());
        admins.add(admin);
        emit(AdminsSuccess(admins));
      }
    } catch (e) {
      emit(AdminsFailure(
        e.toString(),
        admins,
      ));
      log.e('ADD A ADMIN', error: e);
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
      log.e('DELETE ADMIN', error: e);
    }
  }

  Future<void> updateAdmin(AdminModel admin) async {
    try {
      await db.collection(collectionName).doc(admin.id).set(admin.toJson());
    } catch (e) {
      log.e('UPDATE Admin', error: e);
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
