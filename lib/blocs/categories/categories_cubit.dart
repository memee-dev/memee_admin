import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../core/shared/app_logger.dart';
import '../../models/category_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final FirebaseFirestore db;

  CategoriesCubit(this.db) : super(CategoriesLoading());

  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    try {
      final categoryDoc =
          await db.collection(AppFireStoreCollection.categories).get();
      List<CategoryModel> categories = [];
      final docs = categoryDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        categories.add(
          CategoryModel.fromMap(data),
        );
      }

      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(e.toString()));
    }
  }

  void addCategory(String categoryName) {
    emit(CategoriesLoading());
    try {
      CollectionReference categories =
          db.collection(AppFireStoreCollection.categories);
      String sequentialDocId =
          'c${categories.doc().id.length > 1 ? categories.doc().id.substring(1) : '001'}';
      categories.doc(sequentialDocId).set({
        'name': categoryName,
        'status': true,
      });
      emit(CategoriesSuccess());
    } catch (e) {
      emit(CategoriesFailure(e.toString()));
      log.e('ADD CATEGORIES', error: e);
    }
  }

  Future<void> addCategories(List<CategoryModel> categories) async {
    emit(CategoriesLoading());
    final categoryCollection = db.collection(AppFireStoreCollection.categories);
    for (var category in categories) {
      await categoryCollection.doc(category.id).set(category.toJson());
    }
  }

  //edit category
  Future<void> updateCategory(CategoryModel category) async {
    await db
        .collection(AppFireStoreCollection.categories)
        .doc(category.id)
        .set(category.toJson());
  }

  //deactive category

  //delete category
}
