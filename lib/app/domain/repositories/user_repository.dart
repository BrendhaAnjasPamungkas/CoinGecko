// ========== lib/app/domain/repositories/user_repository.dart ==========
import 'package:blockchain/app/domain/entities/owned_coin_entities.dart';


// INI ADALAH INTERFACE (KONTRAK) MURNI
abstract class UserRepository {
  Future<double> getBalance();
  Future<void> updateBalance(double newBalance);
  Future<double> getOwnedCoins(String coinName);
  Future<void> incrementOwnedCoins(String coinName, double delta);

  // TAMBAHKAN FUNGSI BARU INI
  Future<List<OwnedCoinEntity>> getAllOwnedCoins();
}