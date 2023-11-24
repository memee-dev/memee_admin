import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/core/shared/app_logger.dart';
import 'package:memee_admin/models/dl_executive_model.dart';

part 'dl_executive_state.dart';

class DlExecutiveCubit extends Cubit<DlExecutivesState> {
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  final collectionName = AppFireStoreCollection.dlExecutives;

  DlExecutiveCubit(
    this.db,
    this.storage,
  ) : super(DlExecutivesLoading());

  Future<void> fetchDlExecutives() async {
    List<DlExecutiveModel> dlExecutives = [];
    emit(DlExecutivesLoading());
    try {
      final dlExecutivesDoc = await db.collection(collectionName).get();
      final docs = dlExecutivesDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        dlExecutives.add(DlExecutiveModel.fromMap(data));
      }
      emit(DlExecutivesSuccess(dlExecutives));
    } catch (e) {
      emit(DlExecutivesFailure(
        e.toString(),
        dlExecutives,
      ));
      log.e('FETCH DlExecutives', error: e);
    }
  }

  Future<void> addDlExecutive({
    required String name,
    required String email,
    required String phoneNumber,
    required String aadhar,
    String? dlUrl,
    required String dlNumber,
    bool active = true,
    bool alloted = false,
  }) async {
    List<DlExecutiveModel> dlExecutives = getLocalDLExecutives();

    try {
      final ref = db.collection(collectionName);
      int lastNumber = 1;

      late String sequentialDocId;
      if (dlExecutives.isEmpty) {
        sequentialDocId = lastNumber.toString().padLeft(3, '0');
      } else {
        lastNumber = int.parse(dlExecutives.last.id.substring(1));
        sequentialDocId = (lastNumber + 1).toString().padLeft(3, '0');
      }

      sequentialDocId = 'dl$sequentialDocId';

      final dl = DlExecutiveModel(
        id: sequentialDocId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        dlNumber: dlNumber,
        aadhar: aadhar,
      );
      ref.doc(sequentialDocId).set(dl.toJson());
      dlExecutives.add(dl);
      emit(DlExecutivesSuccess(dlExecutives));
    } catch (e) {
      emit(DlExecutivesFailure(
        e.toString(),
        dlExecutives,
      ));
      log.e('ADD a DlExecutive', error: e);
    }
  }

  Future<void> addDlExecutives(
    List<DlExecutiveModel> dlExecutives, {
    bool clearAll = false,
  }) async {
    emit(DlExecutivesLoading());
    try {
      final dlExecutiveCollection = db.collection(collectionName);
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
      emit(DlExecutivesFailure(
        e.toString(),
        const [],
      ));
      log.e('ADD All DlExecutives', error: e);
    }
  }

  Future<void> updateDlExecutive(DlExecutiveModel dlExecutive) async {
    try {
      await db.collection(collectionName).doc(dlExecutive.id).set(dlExecutive.toJson());
    } catch (e) {
      log.e('UPDATE DlExecutive', error: e);
    }
  }

  Future<void> deleteDlExecutive(DlExecutiveModel dlExecutive) async {
    List<DlExecutiveModel> dlExecutives = getLocalDLExecutives();
    try {
      dlExecutives.remove(dlExecutive);
      await db.collection(collectionName).doc(dlExecutive.id).delete();
      emit(DlExecutivesSuccess(dlExecutives));
    } catch (e) {
      emit(DlExecutivesFailure(
        e.toString(),
        dlExecutives,
      ));
      log.e('DELETE CATEGORY', error: e);
    }
  }

  Future<void> deleteAllDlExecutive() async {
    try {
      final dlExecutivesCollection = await db.collection(collectionName).get();
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

  Future<void> updateDLImage(file) async {
    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = storage.ref().child('flutter-tests').child('/some-image.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }

    return Future.value(uploadTask);
  }

  List<DlExecutiveModel> getLocalDLExecutives() {
    List<DlExecutiveModel> dlExecutives = [];
    if (state is DlExecutivesSuccess) {
      dlExecutives.addAll((state as DlExecutivesSuccess).dlExecutives);
    } else if (state is DlExecutivesFailure) {
      dlExecutives.addAll((state as DlExecutivesFailure).dlExecutives);
    }
    return dlExecutives;
  }
}
