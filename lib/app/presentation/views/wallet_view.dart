// ========== lib/app/presentation/views/wallet_view.dart ==========
import 'package:blockchain/app/main_widget.dart';
import 'package:blockchain/app/presentation/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

// Import injection & usecases
import 'package:blockchain/injection.dart';
import 'package:blockchain/app/domain/usecase/user_usecase.dart';
import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';

class WalletView extends StatelessWidget {
  // --- MODIFIKASI 1 ---
  // Hapus 'permanent: true'. Ini akan membuat controller
  // di-dispose saat ditutup dan dibuat ulang (refresh) saat dibuka.
  final WalletController controller = Get.put(
    WalletController(
      userUsecase: sl<UserUsecase>(),
      marketCoinsUsecase: sl<GetMarketCoinsUsecase>(),
    ),
    permanent: false, // <-- UBAH INI
  );

  WalletView({super.key});

  // Helper untuk format mata uang
  String _formatCurrency(double value, {String symbol = '\$'}) {
    return NumberFormat.currency(
      decimalDigits: 2,
      locale: 'id_ID',
      symbol: symbol,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0f172a), // slate-900
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        title: W.text(data: 'My Wallet', color: Colors.white, fontSize: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,

        // --- MODIFIKASI 2 ---
        // Hapus 'actions' (tombol refresh) dari sini
        actions: [],
        // --- BATAS MODIFIKASI ---
      ),
      body: Obx(() {
        // Kita tidak perlu lagi 'RefreshIndicator' karena
        // controller akan me-refresh datanya sendiri di onInit()
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildTotalBalanceCard(controller.totalWalletValue.value),
            W.gap(height: 24),
            _buildAssetSection(context),
          ],
        );
      }),
    );
  }

  // Card untuk Total Saldo
  Widget _buildTotalBalanceCard(double totalValue) {
    // ... (kode widget ini tidak berubah)
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1e3a8a), Color(0xFF1e293b)], // blue-900, slate-800
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          W.text(
            data: 'Total Estimasi Saldo',
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          W.gap(height: 8),
          W.text(
            data: _formatCurrency(totalValue),
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          W.gap(height: 24),
          W.text(
            data: 'Saldo Tunai (USD)',
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
          W.gap(height: 4),
          Obx(
            // Obx kecil khusus untuk saldo USD
            () => W.text(
              data: _formatCurrency(controller.userBalance.value),
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Bagian Daftar Aset
  Widget _buildAssetSection(BuildContext context) {
    // ... (kode widget ini tidak berubah)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        W.text(
          data: 'Aset Koin Saya',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        W.gap(height: 16),

        Obx(() {
          if (controller.ownedDisplayCoins.isEmpty) {
            return Center(
              child: W.text(
                data: 'Anda belum memiliki koin',
                color: Colors.white70,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.ownedDisplayCoins.length,
            itemBuilder: (context, index) {
              final coin = controller.ownedDisplayCoins[index];
              return _buildCoinTile(coin);
            },
          );
        }),
      ],
    );
  }

  // Tile untuk satu koin
  Widget _buildCoinTile(WalletDisplayCoin coin) {
    // ... (kode widget ini tidak berubah)
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Image.network(coin.imageUrl, width: 40, height: 40),
          W.gap(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                W.text(
                  data: coin.name,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                W.gap(height: 4),
                W.text(data: coin.symbol.toUpperCase(), color: Colors.white70),
              ],
            ),
          ),
          W.gap(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              W.text(
                data: _formatCurrency(coin.totalValue),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              W.gap(height: 4),
              W.text(
                data: '${coin.amountOwned} ${coin.symbol.toUpperCase()}',
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
