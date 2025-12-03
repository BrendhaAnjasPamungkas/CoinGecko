// ========== domain/usecase/user_usecase.dart ==========
import 'package:blockchain/app/domain/entities/owned_coin_entities.dart';
import 'package:blockchain/app/domain/repositories/user_repository.dart';

class UserUsecase {
  final UserRepository userRepository; // Dependensi ke Interface
  
  UserUsecase(this.userRepository); // Terima via constructor

  Future<double> getBalance() async {
    return await userRepository.getBalance();
  }

  Future<double> getOwnedCoins(String coinName) async {
    return await userRepository.getOwnedCoins(coinName);
  }

  Future<void> updateBalance(double newBalance) async {
    return await userRepository.updateBalance(newBalance);
  }

  Future<void> incrementOwnedCoins(String coinName, double delta) async {
    return await userRepository.incrementOwnedCoins(coinName, delta);
  }
  Future<List<OwnedCoinEntity>> getAllOwnedCoins() {
    return userRepository.getAllOwnedCoins();
  }

  // Hapus loadOwned dan loadBalance, itu duplikat dan membingungkan
}