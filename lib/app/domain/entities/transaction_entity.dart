// ========== domain/entities/transaction_entity.dart ==========
// Hapus 'import cloud_firestore'
// Ganti Timestamp dengan DateTime agar murni
class TransactionEntity {
  final String coinName;
  final double amount;
  final String type;
  final String userId;
  final DateTime timestamp; // <--- DIGANTI

  TransactionEntity({
    required this.coinName,
    required this.amount,
    required this.type,
    required this.userId,
    required this.timestamp,
  });

  // Konversi ke Map tetap ada, tapi ini akan dipanggil di Layer Data
  Map<String, dynamic> toMap() {
    return {
      'coinName': coinName,
      'amount': amount,
      'type': type,
      'userId': userId,
      'timestamp': timestamp, // Biarkan sebagai DateTime, konversi di Impl
    };
  }

  // Konversi dari Map tetap ada
  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      coinName: map['coinName'],
      amount: map['amount'],
      type: map['type'],
      userId: map['userId'],
      // Firestore mengembalikan Timestamp, konversi di sini
      timestamp: (map['timestamp'] as dynamic).toDate(),
    );
  }
}