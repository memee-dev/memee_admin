import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../core/shared/app_logger.dart';
import '../../models/category_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final FirebaseFirestore db;
  final collectionName = AppFireStoreCollection.categories;

  CategoriesCubit(this.db) : super(CategoriesLoading());

  Future<void> fetchCategories() async {
    List<CategoryModel> categories = [];
    emit(CategoriesLoading());
    try {
      final categoryDoc = await db.collection(collectionName).get();

      final docs = categoryDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        categories.add(CategoryModel.fromMap(data));
      }

      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        categories,
      ));
      log.e('FETCH CATEGORY', error: e);
    }
  }

  void addCategory(String categoryName,String image) {
    List<CategoryModel> categories = getLocalCategories();

    try {
      final ref = db.collection(collectionName);
      int lastNumber = 1;

      late String sequentialDocId;
      if (categories.isEmpty) {
        sequentialDocId = lastNumber.toString().padLeft(3, '0');
      } else {
        lastNumber = int.parse(categories.last.id.substring(1));
        sequentialDocId = (lastNumber + 1).toString().padLeft(3, '0');
      }

      sequentialDocId = 'c$sequentialDocId';

      final category =
          CategoryModel(id: sequentialDocId, name: categoryName, image: image);

      ref.doc(sequentialDocId).set(category.toJson());
      categories.add(category);
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        categories,
      ));
      log.e('ADD CATEGORY', error: e);
    }
  }

  Future<void> addCategories(List<CategoryModel> categories) async {
    emit(CategoriesLoading());
    try {
      final categoryCollection = db.collection(collectionName);
      for (var category in categories) {
        await categoryCollection.doc(category.id).set(category.toJson());
      }
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        const [],
      ));
      log.e('ADD CATEGORIES', error: e);
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await db
          .collection(collectionName)
          .doc(category.id)
          .set(category.toJson());
    } catch (e) {
      log.e('UPDATE CATEGORY', error: e);
    }
  }

  Future<void> deleteCategory(CategoryModel category) async {
    List<CategoryModel> categories = getLocalCategories();
    try {
      categories.remove(category);
      await db.collection(collectionName).doc(category.id).delete();
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        categories,
      ));
      log.e('DELETE CATEGORY', error: e);
    }
  }

  List<CategoryModel> getLocalCategories() {
    List<CategoryModel> categories = [];
    if (state is CategoriesSuccess) {
      categories.addAll((state as CategoriesSuccess).categories);
    } else if (state is CategoriesFailure) {
      categories.addAll((state as CategoriesFailure).categories);
    }
    return categories;
  }
}
