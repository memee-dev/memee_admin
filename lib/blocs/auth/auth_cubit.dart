import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthCubit extends Cubit<AuthStatus> {
  final FirebaseAuth auth;
  final FirebaseFirestore db;

  AuthCubit(this.auth, this.db) : super(AuthStatus.loading);

  Future<void> checkAuthenticationStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    auth.authStateChanges().listen((User? user) async {
      try {
        if (user != null) {
          DocumentSnapshot userDoc =
              await db.collection('admins').doc(user.uid).get();
          if (userDoc.exists) {
            emit(AuthStatus.authenticated);
          } else {
            emit(AuthStatus.unauthenticated);
          }
        } else {
          emit(AuthStatus.unauthenticated);
        }
      } catch (e) {
        emit(AuthStatus.unauthenticated);
      }
    });
  }
}
