import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../core/shared/app_logger.dart';
import '../../models/order_model.dart';
import '../payments/payments_cubit.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final FirebaseFirestore db;
  final collectionName = AppFireStoreCollection.orders;

  OrdersCubit(this.db) : super(OrdersLoading());

  Future<void> fetchOrders() async {
    List<OrderModel> orders = [];
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
