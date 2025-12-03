// ========== data/repositories/transaction_repository_impl.dart ==========
import 'package:blockchain/app/domain/entities/transaction_entity.dart';
import 'package:blockchain/app/domain/repositories/transaction_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _fs;

  // Terima dependensi via constructor (DI)
  TransactionRepositoryImpl({required FirebaseFirestore firestore}) : _fs = firestore;

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      // Konversi DateTime ke Timestamp di sini (Layer Data)
      final map = transaction.toMap();
      map['timestamp'] = Timestamp.fromDate(transaction.timestamp);
      
      await _fs.collection('transactions').add(map);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactions(String userId) async {
    try {
      final querySnapshot = await _fs
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return TransactionEntity.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }
}