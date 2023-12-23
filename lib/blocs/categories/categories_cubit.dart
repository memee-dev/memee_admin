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
  List<CategoryModel> categories = [];
  CategoriesCubit(this.db) : super(CategoriesLoading());

  void refresh() {
    emit(CategoriesLoading());
    emit(CategoriesSuccess(categories));
  }

  int categoriesCount = 0;
  int pageSize = 10;
  int pageNo = 1;
  DocumentSnapshot? lastDocument;

  Future<void> fetchCategories({bool clear = false}) async {
    try {
      final countSnap = await db.collection(collectionName).count().get();
      categoriesCount = countSnap.count;

      if (categoriesCount > categories.length) {
        emit(CategoriesLoading());
        QuerySnapshot<Map<String, dynamic>> categoryDocs;
        if (clear) {
          categories.clear();
          categoryDocs = await db
              .collection(collectionName)
              .orderBy('name')
              .limit(pageSize)
              .get();
        } else {
          categoryDocs = await db
              .collection(collectionName)
              .orderBy('name')
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get();
        }

        final docs = categoryDocs.docs;
        lastDocument = docs.last;

        List<CategoryModel> fetched10Categories = [];
        for (var doc in docs) {
          final data = doc.data();
          data['id'] = doc.id;
          fetched10Categories.add(CategoryModel.fromMap(data));
        }

        categories.addAll(fetched10Categories);
        emit(CategoriesSuccess(fetched10Categories));
      }
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        categories,
      ));
      console.e('FETCH CATEGORY', error: e);
    }
  }

  Future<void> addCategory(
    String categoryName,
    String image,
    bool status,
  ) async {
    List<CategoryModel> categories = getLocalCategories();

    try {
      int lastNumber = 1;

      late String sequentialDocId;
      if (categories.isEmpty) {
        sequentialDocId = lastNumber.toString().padLeft(3, '0');
      } else {
        lastNumber = int.parse(categories.last.id.substring(1));
        sequentialDocId = (lastNumber + 1).toString().padLeft(3, '0');
      }

      sequentialDocId = 'c$sequentialDocId';

      final category = CategoryModel(
        id: sequentialDocId,
        name: categoryName,
        image: image,
        active: status,
      );
      final ref = db.collection(collectionName);
      await ref.doc(sequentialDocId).set(category.toJson());
      categories.add(category);
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        categories,
      ));
      console.e('ADD CATEGORY', error: e);
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
      console.e('ADD CATEGORIES', error: e);
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    List<CategoryModel> categories = getLocalCategories();
    try {
      await db
          .collection(collectionName)
          .doc(category.id)
          .set(category.toJson());
      int index = categories.indexWhere((element) => category.id == element.id);
      categories[index] = category;
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        const [],
      ));
      console.e('UPDATE CATEGORY', error: e);
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
      console.e('DELETE CATEGORY', error: e);
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

  Future<void> removeOldAndAddNewCategories(
      List<CategoryModel> categories) async {
    try {
      this.categories = categories;
      final batch = db.batch();
      var collection = db.collection(collectionName);
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      for (var category in categories) {
        final doc = db.collection(collectionName).doc(category.id);
        batch.set(doc, category.toJson());
      }

      await batch.commit();
    } catch (e) {
      emit(CategoriesFailure(
        e.toString(),
        categories,
      ));
      console.e('Remove Old & Add new Categories', error: e);
    }
  }

  List<List<dynamic>> exportData() {
    List<List<dynamic>> csvData = [];
    csvData.add([
      'ID',
      'Category Name',
      'Category Active',
      'Category Image',
    ]);

    for (CategoryModel category in categories) {
      String id = category.id;
      String name = category.name;
      bool active = category.active;
      String image = category.image;

      csvData.add([
        id,
        name,
        active,
        image,
      ]);
    }
    return csvData;
  }

  Future<void> importData(List<List> csvData) async {
    List<CategoryModel> categories = [];

    for (int i = 1; i < csvData.length; i++) {
      List<dynamic> row = csvData[i];

      categories.add(
        CategoryModel(
          id: row[0],
          name: row[1].toString(),
          active: bool.parse(row[2]),
          image: row[3],
        ),
      );
    }

    await removeOldAndAddNewCategories(categories);
  }
}
