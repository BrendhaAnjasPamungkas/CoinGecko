// ========== domain/repositories/transaction_repository.dart ==========
import 'package:blockchain/app/domain/entities/transaction_entity.dart';

// INI ADALAH INTERFACE (KONTRAK) MURNI
abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions(String userId);
}