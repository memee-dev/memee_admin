import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/core/shared/app_logger.dart';
import 'package:memee_admin/models/dl_executive_model.dart';

import '../../ui/__shared/enums/crud_enum.dart';

part 'dl_executive_state.dart';

class DlExecutiveCubit extends Cubit<DlExecutivesState> {
  final FirebaseFirestore db;

 DlExecutiveCubit(this.db) : super(DlExecutivesLoading());

  Future<void> fetchDlExecutives() async {
    emit(DlExecutivesLoading());
    try {
      final dlExecutivesCollection =
          await db.collection(AppFireStoreCollection.dlExecutives).get();
      final dlExecutiveDocs = dlExecutivesCollection.docs;

      List<DlExecutiveModel> dlExecutives = [];
      for (var doc in dlExecutiveDocs) {
        final data = doc.data();
        data['id'] = doc.id;
        dlExecutives.add(DlExecutiveModel.fromMap(data));
      }
      emit(DlExecutivesSuccess(dlExecutives));
    } catch (e) {
      log.e('FETCH DlExecutives', error: e);
      emit(DlExecutivesFailure(e.toString()));
    }
  }

  Future<void> addDlExecutives(
    List<DlExecutiveModel> dlExecutives, {
    bool clearAll = false,
  }) async {
    emit(DlExecutivesLoading());
    try {
      final dlExecutiveCollection = db.collection(AppFireStoreCollection.dlExecutives);
      if (clearAll) {
        deleteAllDlExecutive();
      }
      final batch = db.batch();
      for (var user in dlExecutives) {
        batch.set(dlExecutiveCollection.doc(), user.toJson());
      }
      batch.commit();

      emit(DlExecutivesSuccess(dlExecutives));
    } catch (e) {
      log.e('ADD All DlExecutives', error: e);
      emit(DlExecutivesFailure(e.toString()));
    }
  }

  Future<void> addDlExecutive(DlExecutiveModel dlExecutive) async {
    try {
      await db.collection(AppFireStoreCollection.dlExecutives).add(dlExecutive.toJson());
      crudLocally(dlExecutive, CRUD.create);
    } catch (e) {
      log.e('ADD a DlExecutive', error: e);
    }
  }

  Future<void> updateDlExecutive(DlExecutiveModel dlExecutive) async {
    try {
      await db
          .collection(AppFireStoreCollection.dlExecutives)
          .doc(dlExecutive.id)
          .set(dlExecutive.toJson());
      crudLocally(dlExecutive, CRUD.update);
    } catch (e) {
      log.e('UPDATE a DlExecutive', error: e);
    }
  }

  Future<void> deleteDlExecutive(DlExecutiveModel dlExecutive) async {
    try {
      await db.collection(AppFireStoreCollection.dlExecutives).doc(dlExecutive.id).delete();
      crudLocally(dlExecutive, CRUD.delete);
    } catch (e) {
      log.e('DELETE a DlExecutive', error: e);
    }
  }

  Future<void> deleteAllDlExecutive() async {
    try {
      final dlExecutivesCollection =
          await db.collection(AppFireStoreCollection.dlExecutives).get();
      final dlExecutiveDocs = dlExecutivesCollection.docs;

      final batch = db.batch();
      for (var doc in dlExecutiveDocs) {
        batch.delete(doc.reference);
      }
      batch.commit();
    } catch (e) {
      log.e('DELETE All DlExecutive', error: e);
    }
  }

  void crudLocally(DlExecutiveModel dlExecutive, CRUD crud) {
    try {
      if (state is DlExecutivesSuccess) {
        final dlExecutives = (state as DlExecutivesSuccess).dlExecutives;
        if (crud == CRUD.create) {
          dlExecutives.add(dlExecutive);
          emit(DlExecutivesLoading());
          emit(DlExecutivesSuccess(dlExecutives));
        } else {
          int index = (state as DlExecutivesSuccess)
              .dlExecutives
              .indexWhere((existingDlExecutive) => existingDlExecutive.id == dlExecutive.id);

          if (index != -1) {
            if (crud == CRUD.update) {
              dlExecutives[index] = dlExecutive;
            } else if (crud == CRUD.delete) {
              dlExecutives.removeAt(index);
            }
            emit(DlExecutivesLoading());
            emit(DlExecutivesSuccess(dlExecutives));
          } else {
            log.e('updateDlExecutiveLocally', error: 'Not found');
          }
        }
      }
    } catch (e) {
      log.e('updateDlExecutiveLocally', error: e);
    }
  }
}

