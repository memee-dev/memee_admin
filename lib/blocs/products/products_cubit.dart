import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';
import 'package:memee_admin/models/category_model.dart';

import '../../core/shared/app_logger.dart';
import '../../models/product_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FirebaseFirestore db;
  final collectionName = AppFireStoreCollection.products;

  ProductsCubit(this.db) : super(ProductsLoading());

  Future<void> fetchProducts() async {
    List<ProductModel> products = [];
    emit(ProductsLoading());
    try {
      final prodDoc = await db.collection(collectionName).get();
      final docs = prodDoc.docs;

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

  Future<void> addProduct({
    required String name,
    required CategoryModel category,
    required String description,
    List<String>? images,
    required List<ProductDetailsModel> productDetails,
    bool active = true,
  }) async {
    List<ProductModel> products = getLocalProducts();

    try {
      final ref = db.collection(collectionName);
      int lastNumber = 0;

      ref
          .where(
            'categoryId',
            isEqualTo: category.id,
          )
          .orderBy('id', descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          lastNumber =
              int.parse(querySnapshot.docs.first['productId'].substring(6));
        }

        // Increment the product number and format the productId
        int nextNumber = lastNumber + 1;
        String formattedProductNumber = nextNumber.toString().padLeft(4, '0');

        // Generate the product ID in the specified format
        String productId =
            'p${category.id.substring(1).padLeft(3, '0')}${formattedProductNumber.padLeft(4, '0')}';

        final product = ProductModel(
          id: productId,
          name: name,
          category: category,
          description: description,
          images: images,
          productDetails: productDetails,
        );

        ref.doc(productId).set(product.toJson());
        products.add(product);
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
      await db.collection(collectionName).doc(product.id).set(product.toJson());
    } catch (e) {
      log.e('UPDATE Product', error: e);
    }
  }
Future<void> deleteProducts(ProductModel product) async {
    List<ProductModel> products = getLocalProducts();
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
  List<ProductModel> getLocalProducts() {
    List<ProductModel> products = [];
    if (state is ProductsSuccess) {
      products.addAll((state as ProductsSuccess).products);
    } else if (state is ProductsFailure) {
      products.addAll((state as ProductsFailure).products);
    }
    return products;
  }
}
