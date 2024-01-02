import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memee_admin/core/initializer/app_aloglia.dart';
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
  ProductsCubit(this.db, this.storage) : super(ProductsEmpty());

  void refresh() {
    emit(ProductsLoading());
    emit(ProductsSuccess(products));
  }

  int productsCount = 0;
  int pageSize = 20;
  int pageNo = 1;
  DocumentSnapshot? lastDocument;
  Future<void> fetchProducts({bool clear = false}) async {
    try {
      final countSnap = await db.collection(collectionName).count().get();
      productsCount = countSnap.count;

      if (productsCount > products.length) {
        emit(ProductsLoading());
        QuerySnapshot<Map<String, dynamic>> productDocs;
        if (clear) {
          products.clear();
          productDocs =
              await db.collection(collectionName).limit(pageSize).get();
        } else {
          productDocs = await db
              .collection(collectionName)
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get();
        }

        final docs = productDocs.docs;
        lastDocument = docs.last;

        List<ProductModel> fetched10Products = [];
        for (var doc in docs) {
          final data = doc.data();
          data['id'] = doc.id;
          fetched10Products.add(ProductModel.fromMap(data));
        }

        products.addAll(fetched10Products);
        emit(ProductsSuccess(fetched10Products));
      }
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      console.e('FETCH PRODUCTS', error: e);
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
            .get<ProductAlgolia>()
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
      console.e('SEARCH Products', error: e);
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
          categoryId: category.id,
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
        console.e('ADD a Product', error: e);
      });
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      console.e('ADD a Product', error: e);
    }
  }

  Future<void> removeOldAndAddNewProducts(List<ProductModel> products) async {
    try {
      this.products = products;
      final batch = db.batch();
      var collection = db.collection(collectionName);
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      for (var product in products) {
        final doc = db.collection(collectionName).doc(product.id);
        batch.set(doc, product.toJson());
      }

      await batch.commit();
    } catch (e) {
      emit(ProductsFailure(
        e.toString(),
        products,
      ));
      console.e('Remove Old & Add new Products', error: e);
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
      console.e('UPDATE CATEGORY', error: e);
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
      console.e('DELETE PRODUCT', error: e);
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
      console.e('DELETE PRODUCT', error: e);
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

  List<List<dynamic>> exportData() {
    List<List<dynamic>> csvData = [];
    csvData.add([
      'Product ID',
      'Product Name',
      'Category ID',
      'Description',
      'Product Active',
      'Images',
      'Details',
    ]);

    for (ProductModel product in products) {
      String id = product.id;
      String name = product.name;
      String categoryId = product.categoryId;
      String description = product.description;
      bool productActive = product.active;
      List<String> images = product.images;
      List<String> details = product.productDetails
          .map(
            (x) => x.toString(allowCurly: true),
          )
          .toList();
      csvData.add([
        id,
        name,
        categoryId,
        description,
        productActive,
        images.join(', '),
        details.join(', '),
      ]);
    }
    return csvData;
  }

  Future<void> importData(List<List> csvData) async {
    List<ProductModel> products = [];

    for (int i = 1; i < csvData.length; i++) {
      List<dynamic> row = csvData[i];

      List<String> images =
          (row[5].split(', ') as List<String>).map((var image) {
        return image.trim().toString();
      }).toList();

      List<ProductDetailsModel> details =
          (row[6].toString().split('},')).map((var d) {
        final val = d.replaceFirst('{', '').replaceFirst('}', '');
        final v = val.split(', ');
        final p = ProductDetailsModel(
          price: double.parse(v[0].split(':')[1]),
          discountedPrice: double.parse(v[1].split(':')[1]),
          qty: double.parse(v[2].split(':')[1]),
          type: ProductDetailsModel.parseProductType(v[3].split(':')[1].trim()),
        );
        return p;
      }).toList();

      products.add(
        ProductModel(
          id: row[0],
          name: row[1],
          categoryId: row[2],
          description: row[3],
          active: bool.parse(row[4].toLowerCase()),
          images: images,
          productDetails: details,
        ),
      );
    }

    await removeOldAndAddNewProducts(products);
  }
}
