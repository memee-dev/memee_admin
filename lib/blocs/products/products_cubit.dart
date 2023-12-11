

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/models/category_model.dart';

import '../../core/initializer/app_di_registration.dart';
import '../../core/shared/app_logger.dart';
import '../../models/product_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FirebaseFirestore db;
  final FirebaseStorage storage;
  final collectionName = AppFireStoreCollection.products;

  List<ProductModel> products = [];
  ProductsCubit(this.db, this.storage) : super(ProductsLoading());

  Future<void> fetchProducts() async {
    emit(ProductsLoading());
    try {
      final prodDoc = await db.collection(collectionName).get();
      final docs = prodDoc.docs;
      products.clear();
      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        products.add(ProductModel.fromMap(data));
      }
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      log.e('FETCH Products', error: e);
    }
  }

  bool searching = false;
  Future<void> searchProducts(String searchQuery) async {
    List<ProductModel> _searchedProducts = [];
    try {
      searchQuery = searchQuery.trim();
      if (searchQuery.trim().length > 2) {
        emit(ProductsLoading());
        searching = true;
        final query = locator
            .get<Algolia>()
            .instance
            .index(AppFireStoreCollection.products)
            .query(searchQuery);
        final snap = await query.getObjects();
        final hits = snap.hits;

        for (var hit in hits) {
          _searchedProducts.add(
              products.firstWhere((element) => element.id == hit.objectID));
        }

        emit(ProductsSuccess(_searchedProducts));
      } else {
        if (searching) {
          emit(ProductsLoading());
          emit(ProductsSuccess(products));
        }
      }
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      log.e('FETCH Products', error: e);
    }
  }

  Future<void> addProduct({
    required String name,
    required CategoryModel category,
    required String description,
    List<String> images = const [],
    required List<ProductDetailsModel> productDetails,
    bool active = true,
  }) async {
    try {
      final ref = db.collection(collectionName);
      int lastNumber = 0;

      ref
          .where(
            'categoryId',
            isEqualTo: category.id,
          )
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          lastNumber = int.parse(querySnapshot.docs.first.id
              .substring(1 + category.id.substring(1).length));
        }

        int nextNumber = lastNumber + 1;
        String productId = 'p${category.id.substring(1)}$nextNumber';

        final List<String> uploadedImages = await uploadImageToFStorage(
          AppFireStoreCollection.products,
          productId,
        );
        images.addAll(uploadedImages);
        final product = ProductModel(
          id: productId,
          name: name,
          category: category,
          description: description,
          images: images,
          productDetails: productDetails,
        );
        final data = product.toJson();
        data['createdAt'] = DateTime.now();
        data['updatedAt'] = DateTime.now();
        data['categoryId'] = category.id;

        await ref.doc(productId).set(data);
        products.add(product);
        emit(ProductsLoading());
        emit(ProductsSuccess(products));
      }).catchError((e) {
        emit(ProductsFailure(
          e.toString(),
          products,
        ));
        log.e('ADD a Product', error: e);
      });
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      log.e('ADD a Product', error: e);
    }
  }

  Future<void> updateProducts(ProductModel product) async {
    try {
      final List<String> uploadedImages = await uploadImageToFStorage(
        AppFireStoreCollection.products,
        product.id,
      );
      product.images.addAll(uploadedImages);
      final data = product.toJson();
      data['updatedAt'] = DateTime.now();
      await db.collection(collectionName).doc(product.id).set(data);
      int index = products.indexWhere((element) => product.id == element.id);
      products[index] = product;
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        const [],
      ));
      log.e('UPDATE CATEGORY', error: e);
    }
  }

  Future<void> deleteProducts(ProductModel product) async {
    try {
      products.remove(product);
      await db.collection(collectionName).doc(product.id).delete();
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      log.e('DELETE PRODUCT', error: e);
    }
  }

  List<XFile> productImageFiles = [];
  Future<void> uploadProductImageToStorage() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        productImageFiles.add(file);
      }
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      log.e('DELETE PRODUCT', error: e);
    }
  }

  Future<List<String>> uploadImageToFStorage(
      String path, String folderName) async {
    final List<String> uploadedImages = [];
    if (kIsWeb) {
      for (var file in productImageFiles) {
        final unqFilesName = DateTime.now().millisecondsSinceEpoch.toString();
        final _reference =
            storage.ref().child(path).child(folderName).child(unqFilesName);
        await _reference
            .putData(
          await file.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        )
            .whenComplete(() async {
          await _reference.getDownloadURL().then((value) {
            uploadedImages.add(value);
          });
        });
      }
    }
    return uploadedImages;
  }
}
