// ========== domain/usecase/transaction_usecase.dart ==========
import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/domain/entities/transaction_entity.dart';
import 'package:blockchain/app/domain/repositories/transaction_repository.dart';
import 'package:blockchain/app/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <--- HAPUS IMPORT INI
// Hapus semua import 'cloud_firestore' dan 'firebase_auth'

class TransactionUseCase {
  final TransactionRepository transactionRepository;
  final UserRepository userRepository; // <-- BUTUH INI
  final FirebaseAuth _auth; // Butuh auth untuk dapat UID

  TransactionUseCase({
    required this.transactionRepository,
    required this.userRepository,
    required FirebaseAuth auth, // Terima via constructor
  }) : _auth = auth;

  String? get _uid => _auth.currentUser?.uid;

  double _priceAsDouble(String s) => double.tryParse(s) ?? 0.0;

  Future<void> buyCoin(Coin coin, double amount) async {
    if (amount <= 0) throw Exception('Amount must be greater than 0');
    final price = _priceAsDouble(coin.currentPrice);
    final totalCost = amount * price;

    final balance = await userRepository.getBalance();
    if (balance < totalCost) throw Exception('Insufficient balance');

    final uid = _uid;
    if (uid == null) throw Exception('User not authenticated');

    // 1) simpan transaksi
    await transactionRepository.addTransaction(
      TransactionEntity(
        coinName: coin.name,
        amount: amount,
        type: 'buy',
        userId: uid,
        timestamp: DateTime.now(), // <-- Gunakan DateTime
      ),
    );

    // 2) update saldo & holdings
    await userRepository.updateBalance(balance - totalCost);
    await userRepository.incrementOwnedCoins(coin.name, amount);
  }

  Future<void> sellCoin(Coin coin, double amount) async {
    if (amount <= 0) throw Exception('Amount must be greater than 0');

    final owned = await userRepository.getOwnedCoins(coin.name);
    if (owned < amount) throw Exception('Insufficient coins');

    final uid = _uid;
    if (uid == null) throw Exception('User not authenticated');

    final price = _priceAsDouble(coin.currentPrice);
    final totalGain = amount * price;

    // 1) simpan transaksi
    await transactionRepository.addTransaction(
      TransactionEntity(
        coinName: coin.name,
        amount: amount,
        type: 'sell',
        userId: uid,
        timestamp: DateTime.now(), // <-- Gunakan DateTime
      ),
    );

    // 2) update holdings & saldo
    await userRepository.incrementOwnedCoins(coin.name, -amount);
    final balance = await userRepository.getBalance();
    await userRepository.updateBalance(balance + totalGain);
  }
}