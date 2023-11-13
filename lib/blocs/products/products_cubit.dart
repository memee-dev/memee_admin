import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../models/product_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final FirebaseFirestore db;

  ProductsCubit(this.db) : super(ProductsLoading());

  Future<void> fetchProducts() async {
    emit(ProductsLoading());
    try {
      final prodDoc =
          await db.collection(AppFireStoreCollection.products).get();
      List<ProductModel> products = [];
      final docs = prodDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        products.add(
          ProductModel(
            id: doc.id,
            name: data['name'],
            description: data['description'],
          ),
        );
      }
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsFailure(e.toString()));
    }
  }
}
