// ========== lib/app/data/datasource/auth_datasource.dart ==========
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blockchain/app/domain/entities/user.dart'; // Pastikan UserEntity sudah benar

class AuthDatasource {
  // 1. Hapus '.instance' dari sini. Kita akan menerimanya dari constructor.
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  // 2. Buat constructor untuk MENERIMA dependensi
  AuthDatasource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _firebaseAuth = auth;

  // 
  // --- SEMUA FUNGSI DI BAWAH INI SAMA PERSIS, TIDAK PERLU DIUBAH ---
  //

  // Fungsi untuk menambahkan pengguna ke Firestore
  Future<void> addUserToFirestore(String uid, String name, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'balance': 1000, // Saldo awal 1000
        'uid': uid,
      });
    } catch (e) {
      throw Exception('Failed to add user to Firestore: $e');
    }
  }

  // Fungsi untuk registrasi pengguna baru menggunakan Firebase Authentication
  Future<UserEntity> register(String email, String password) async {
    try {
      // Mendaftar pengguna menggunakan email dan password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil UID pengguna yang baru terdaftar
      String uid = userCredential.user!.uid;

      // Menambahkan data pengguna ke Firestore
      await addUserToFirestore(
          uid, 'Default Name', email); // Ganti 'Default Name' dengan nilai yang diinginkan

      // Mengembalikan UserEntity setelah berhasil terdaftar
      return UserEntity(
        uid: uid,
        email: email,
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Fungsi untuk login pengguna
  Future<UserEntity> login(String email, String password) async {
    try {
      // Login dengan email dan password
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mengembalikan UserEntity setelah login berhasil
      return UserEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}