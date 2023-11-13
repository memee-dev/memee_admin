import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memee_admin/models/admin_model.dart';

// Define the states for the login process.
enum LoginStatus { initial, loading, success, failure }

class LoginCubit extends Cubit<LoginStatus> {
  final FirebaseAuth auth;
  final FirebaseFirestore db;
  late AdminModel? loginUser;

  LoginCubit(this.auth, this.db) : super(LoginStatus.initial);

  // This method is used to initiate the login process.
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginStatus.loading);

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await db.collection('admins').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          data['id'] = user.uid;
          loginUser = AdminModel.fromMap(data);
          emit(LoginStatus.success);
        } else {
          auth.signOut();
          emit(LoginStatus.failure);
        }
      } else {
        auth.signOut();
        emit(LoginStatus.failure);
      }
    } catch (e) {
      auth.signOut();
      emit(LoginStatus.failure);
    }
  }

  // Reset the state to the initial state.
  void reset() {
    auth.signOut();
    loginUser = null;
    emit(LoginStatus.initial);
  }
}
