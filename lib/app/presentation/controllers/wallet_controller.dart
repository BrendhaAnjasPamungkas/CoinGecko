// ========== lib/app/presentation/controllers/wallet_controller.dart ==========
import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/domain/entities/owned_coin_entities.dart';

import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';
import 'package:blockchain/app/domain/usecase/user_usecase.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

// Ini adalah model data khusus untuk UI Wallet
class WalletDisplayCoin {
  final String name;
  final String symbol;
  final String imageUrl;
  final double amountOwned;
  final double currentPrice;
  final double totalValue; // (amountOwned * currentPrice)

  WalletDisplayCoin({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.amountOwned,
    required this.currentPrice,
    required this.totalValue,
  });
}

class WalletController extends GetxController {
  final UserUsecase userUsecase;
  final GetMarketCoinsUsecase marketCoinsUsecase;

  WalletController({
    required this.userUsecase,
    required this.marketCoinsUsecase,
  });

  // === STATES ===
  final isLoading = true.obs;
  // Saldo USD Murni (dari 'users' collection)
  final userBalance = 0.0.obs;
  // Total nilai koin (Saldo USD + total nilai semua koin)
  final totalWalletValue = 0.0.obs;
  // Daftar koin yang dimiliki untuk ditampilkan
  final ownedDisplayCoins = <WalletDisplayCoin>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      isLoading.value = true;

      // 1. Ambil 3 data utama secara bersamaan
      final results = await Future.wait([
        userUsecase.getBalance(),
        userUsecase.getAllOwnedCoins(),
        marketCoinsUsecase.call(),
      ]);

      // 2. Ekstrak hasil
      final balance = results[0] as double;
      final ownedCoinsRaw = results[1] as List<OwnedCoinEntity>;
      final marketCoins = results[2] as List<Coin>;
      final ownedCoins = ownedCoinsRaw
          .where((coin) => coin.amount > 0)
          .toList();

      // 3. Update saldo USD
      userBalance.value = balance;

      // 4. Proses & Gabungkan data koin
      final List<WalletDisplayCoin> displayList = [];
      double calculatedCoinValue = 0.0;

      // Buat Map marketCoins untuk pencarian cepat (id -> Coin)
      final marketMap = {for (var coin in marketCoins) coin.id: coin};

      for (var owned in ownedCoins) {
        // Cari data market untuk koin yg dimiliki
        final marketData = marketMap[owned.id];

        if (marketData != null) {
          final currentPrice = double.tryParse(marketData.currentPrice) ?? 0.0;
          final totalValue = owned.amount * currentPrice;

          displayList.add(
            WalletDisplayCoin(
              name: marketData.name,
              symbol: marketData.symbol,
              imageUrl: marketData.image,
              amountOwned: owned.amount,
              currentPrice: currentPrice,
              totalValue: totalValue,
            ),
          );
          calculatedCoinValue += totalValue;
        }
      }

      // 5. Set state final
      ownedDisplayCoins.value = displayList;
      totalWalletValue.value = balance + calculatedCoinValue;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data wallet: $e',
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
