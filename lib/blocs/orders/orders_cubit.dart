import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../core/initializer/app_aloglia.dart';
import '../../core/initializer/app_di_registration.dart';
import '../../core/shared/app_logger.dart';
import '../../models/order_model.dart';
import '../payments/payments_cubit.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirebaseFirestore db;
  final collectionName = AppFireStoreCollection.orders;
  List<OrderModel> orders = [];

  OrdersCubit(this.db) : super(OrdersEmpty());
  void refresh() {
    emit(OrdersLoading());
    emit(OrdersSuccess(orders));
  }
   int ordersCount = 0;
  int pageSize = 20;
  int pageNo = 1;
  DocumentSnapshot? lastDocument;

  Future<void> fetchOrders({bool clear = false}) async {
    try {
      final countSnap = await db.collection(collectionName).count().get();
      ordersCount = countSnap.count;

      if (ordersCount > orders.length) {
        emit(OrdersLoading());
        QuerySnapshot<Map<String, dynamic>> orderDocs;
        if (clear) {
          orders.clear();
          orderDocs =
              await db.collection(collectionName).limit(pageSize).get();
        } else {
          orderDocs = await db
              .collection(collectionName)
              .startAfterDocument(lastDocument!)
              .limit(pageSize)
              .get();
        }

        final docs = orderDocs.docs;
        lastDocument = docs.last;

        List<OrderModel> fetched10Orders = [];
        for (var doc in docs) {
          final data = doc.data();
          data['id'] = doc.id;
          fetched10Orders.add(OrderModel.fromMap(data));
        }

        orders.addAll(fetched10Orders);
        emit(OrdersSuccess(fetched10Orders));
      }
    } catch (e) {
      emit(OrdersFailure(
        e.toString(),
        orders,
      ));
      console.e('FETCH ORDERS', error: e);
    }
  }

  // Future<void> fetchOrders1() async {
  //   emit(OrdersLoading());
  //   try {
  //     final orderDoc = await db.collection(collectionName).get();

  //     final docs = orderDoc.docs;
  //     orders.clear();
  //     for (var doc in docs) {
  //       final data = doc.data();
  //       data['id'] = doc.id;
  //       orders.add(OrderModel.fromMap(data));
  //     }

  //     emit(OrdersSuccess(orders));
  //   } catch (e) {
  //     emit(OrdersFailure(
  //       e.toString(),
  //       orders,
  //     ));
  //     console.e('FETCH ORDERS', error: e);
  //   }
  // }

  Color getColorForOrderStatus(String? orderStatus) {
    switch (orderStatus?.toLowerCase()) {
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.lightGreen;
      default:
        return Colors.transparent;
    }
  }

  bool searching = false;
  Future<void> searchOrders(String searchQuery) async {
    List<OrderModel> _searchedOrders = [];
    try {
      searchQuery = searchQuery.trim();
      if (searchQuery.trim().length > 2) {
        emit(OrdersLoading());
        searching = true;
        final query = locator
            .get<OrderAlgolia>()
            .instance
            .index(AppFireStoreCollection.orders)
            .query(searchQuery);
        final snap = await query.getObjects();
        final hits = snap.hits;

        for (var hit in hits) {
          _searchedOrders
              .add(orders.firstWhere((element) => element.id == hit.objectID));
        }

        emit(OrdersSuccess(_searchedOrders));
      } else {
        if (searching) {
          emit(OrdersLoading());
          emit(OrdersSuccess(orders));
        }
      }
    } catch (e) {
      emit(OrdersFailure(
        e.toString(),
        orders,
      ));
      console.e('SEARCH Orders', error: e);
    }
  }

  List<OrderModel> getLocalOrders() {
    List<OrderModel> orders = [];
    if (state is OrdersSuccess) {
      orders.addAll((state as OrdersSuccess).orders);
    } else if (state is PaymentsFailure) {
      orders.addAll((state as OrdersFailure).orders);
    }
    return orders;
  }
}
