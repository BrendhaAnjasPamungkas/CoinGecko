

import 'package:cloud_firestore/cloud_firestore.dart';

class OwnedCoinEntity {
  final String id;
  final double amount;
  
  // --- PERBAIKAN: Buat 'updatedAt' opsional (nullable) ---
  final DateTime? updatedAt; 

  OwnedCoinEntity({
    required this.id,
    required this.amount,
    this.updatedAt, // <-- Dibuat opsional
  });

  // --- PERBAIKAN: Buat 'fromMap' aman dari data null ---
  factory OwnedCoinEntity.fromMap(String id, Map<String, dynamic> map) {
    // Ambil timestamp-nya
    final dynamic timestampData = map['updatedAt'];
    
    // Cek datanya. Jika ada, konversi. Jika null, biarkan null.
    DateTime? safeUpdatedAt;
    if (timestampData is Timestamp) {
      safeUpdatedAt = timestampData.toDate();
    } else if (timestampData != null) {
      // Cadangan jika formatnya bukan timestamp (meski seharusnya)
      safeUpdatedAt = DateTime.now(); 
    }

    return OwnedCoinEntity(
      id: id,
      // Buat 'amount' aman juga
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      
      // Masukkan tanggal yang sudah aman
      updatedAt: safeUpdatedAt,
    );
  }
}