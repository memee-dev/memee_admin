import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/core/shared/app_firestore.dart';

import '../../core/shared/app_logger.dart';
import '../../models/payment_model.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  final FirebaseFirestore db;
  final collectionName = AppFireStoreCollection.payments;

  PaymentsCubit(this.db) : super(PaymentsLoading());

  Future<void> fetchPayments() async {
    List<PaymentModel> payments = [];
    emit(PaymentsLoading());
    try {
      final paymentDoc = await db.collection(collectionName).get();

      final docs = paymentDoc.docs;

      for (var doc in docs) {
        final data = doc.data();
        data['id'] = doc.id;
        payments.add(PaymentModel.fromMap(data));
      }

      emit(PaymentsSuccess(fakePayments));
    } catch (e) {
      emit(PaymentsFailure(
        e.toString(),
        payments,
      ));
      console.e('FETCH PAYMENT', error: e);
    }
  }
  Color getColorForPaymentStatus(String? paymentStatus) {
    switch (paymentStatus?.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'failure':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors
            .transparent; 
    }
  }

  List<PaymentModel> getLocalPayments() {
    List<PaymentModel> payments = [];
    if (state is PaymentsSuccess) {
      payments.addAll((state as PaymentsSuccess).payments);
    } else if (state is PaymentsFailure) {
      payments.addAll((state as PaymentsFailure).payments);
    }
    return payments;
  }
}
