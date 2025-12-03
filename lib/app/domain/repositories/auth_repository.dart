import 'package:blockchain/app/domain/entities/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
abstract class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk login
  Future<UserEntity> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Fungsi untuk registrasi
  Future<UserEntity> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Fungsi untuk menambahkan data pengguna ke Firestore
  Future<void> addUserToFirestore(String uid, String name, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'balance': 1000,  // Saldo awal 1000
        'uid': uid,
      });
      print("User data added to Firestore");
    } catch (e) {
      throw Exception('Failed to add user to Firestore: $e');
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

