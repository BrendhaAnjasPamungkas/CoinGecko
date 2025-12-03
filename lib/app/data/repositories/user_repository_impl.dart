// ========== data/repositories/user_repository_impl.dart ==========
import 'package:blockchain/app/domain/entities/owned_coin_entities.dart';
import 'package:blockchain/app/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Implementasi interface dari domain
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _fs;
  final FirebaseAuth _auth;

  // Terima dependensi via constructor (DI)
  UserRepositoryImpl({required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _fs = firestore,
        _auth = auth;

  User? get _currentUser => _auth.currentUser;

  @override
  Future<double> getBalance() async {
    final u = _currentUser;
    if (u == null) return 0.0;
    final doc = await _fs.collection('users').doc(u.uid).get();
    final v = doc.data()?['balance'];
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return 0.0;
  }

  @override
  Future<void> updateBalance(double newBalance) async {
    final u = _currentUser;
    if (u == null) return;
    await _fs.collection('users').doc(u.uid).update({'balance': newBalance});
  }

  String _coinKey(String coinName) {
    return coinName.trim().toLowerCase();
  }

  @override
  Future<double> getOwnedCoins(String coinName) async {
    final u = _currentUser;
    if (u == null) return 0.0;
    final doc = await _fs
        .collection('userCoins')
        .doc(u.uid)
        .collection('coins')
        .doc(_coinKey(coinName))
        .get();
    final v = doc.data()?['amount'];
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return 0.0;
  }
  @override
  Future<List<OwnedCoinEntity>> getAllOwnedCoins() async {
    final u = _currentUser;
    if (u == null) return []; // Kembalikan list kosong jika user null

    try {
      final querySnapshot = await _fs
          .collection('userCoins')
          .doc(u.uid)
          .collection('coins')
          // Hanya ambil koin yg jumlahnya > 0
          .orderBy('updatedAt', descending: true) // Urutkan
          .get();

      if (querySnapshot.docs.isEmpty) {
        return []; // Kembalikan list kosong
      }

      // Ubah tiap dokumen menjadi OwnedCoinEntity
      return querySnapshot.docs.map((doc) {
        return OwnedCoinEntity.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      // Handle error
      print('Error getting all owned coins: $e');
      throw Exception('Gagal mengambil data koin: $e');
    }
  }

  @override
  Future<void> incrementOwnedCoins(String coinName, double delta) async {
    final u = _currentUser;
    if (u == null) return;

    final ref = _fs
        .collection('userCoins')
        .doc(u.uid)
        .collection('coins')
        .doc(_coinKey(coinName));

    await _fs.runTransaction((tx) async {
      final snap = await tx.get(ref);
      double currentAmount = 0.0;

      if (snap.exists) {
        final data = snap.data();
        final v = data?['amount'];
        if (v is int) currentAmount = v.toDouble();
        if (v is double) currentAmount = v;
      }
      
      final next = currentAmount + delta;
      
      tx.set(
        ref,
        {
          'amount': next < 0 ? 0.0 : next,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: !snap.exists) // Set baru jika tidak ada, merge jika ada
      );
    });
  }
}