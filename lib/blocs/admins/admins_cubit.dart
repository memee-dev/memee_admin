import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../models/admin_model.dart';

part 'admins_state.dart';

class AdminsCubit extends Cubit<AdminsState> {
  final FirebaseFirestore db;

  AdminsCubit(this.db) : super(AdminsLoading());

  Future<void> fetchAdmins() async {
    emit(AdminsLoading());
    try {
      final adminDoc = await db.collection(AppFireStoreCollection.admins).get();
      List<AdminModel> admins = [];
      final docs = adminDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        admins.add(
          AdminModel.fromMap(data),
        );
      }

      emit(AdminsSuccess(admins));
    } catch (e) {
      emit(AdminsFailure(e.toString()));
    }
  }

  Future<void> addAdmins(List<AdminModel> admins) async {
    emit(AdminsLoading());
    final adminCollection = db.collection(AppFireStoreCollection.admins);
    for (var admin in admins) {
      await adminCollection.doc(admin.id).set(admin.toJson());
    }

    emit(AdminsSuccess(admins));
  }

  //edit category
  Future<void> updateAdmin(
    AdminModel admin,
  ) async {
    await db.collection(AppFireStoreCollection.admins).doc(admin.id).set(admin.toJson());
  }

//deactive category

//delete category
}
