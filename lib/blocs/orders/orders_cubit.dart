import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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

  OrdersCubit(this.db) : super(OrdersLoading());

  Future<void> fetchOrders() async {
  
    emit(OrdersLoading());
    try {
      final orderDoc = await db.collection(collectionName).get();

      final docs = orderDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        orders.add(OrderModel.fromMap(data));
      }

      emit(OrdersSuccess(orders));
    } catch (e) {
      emit(OrdersFailure(
        e.toString(),
        orders,
      ));
      console.e('FETCH ORDERS', error: e);
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
