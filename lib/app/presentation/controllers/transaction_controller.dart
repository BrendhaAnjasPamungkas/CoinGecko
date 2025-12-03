// ========== presentation/controllers/transaction_controller.dart ==========
import 'package:blockchain/app/domain/usecase/transaction_usecase.dart';
import 'package:blockchain/app/domain/usecase/user_usecase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/coin.dart';

// --- IMPORT BARU ---
import 'package:blockchain/app/domain/usecase/get_coin_chart_usecase.dart';

class TransactionController extends GetxController {
  // --- DEPENDENSI LAMA ---
  final TransactionUseCase usecase;
  final UserUsecase userUsecase;
  final Coin coin;

  // --- DEPENDENSI BARU ---
  final GetCoinChartUsecase getCoinChartUsecase;

  TransactionController({
    required this.coin,
    required this.usecase,
    required this.userUsecase,
    required this.getCoinChartUsecase, // <-- Tambahkan
  });

  // --- STATE LAMA ---
  final userBalance = 0.0.obs;
  final ownedForCurrent = 0.0.obs;
  final amountCtrl = TextEditingController();
  final amountRx = 0.0.obs;
  final isLoading = false.obs; // Ini untuk transaksi

  // --- STATE BARU UNTUK CHART ---
  final isChartLoading = true.obs;
  final selectedDays = '7'.obs;
  final List<String> dayOptions = ['1', '7', '30', '90', 'max'];
  // Data chart yang sudah diproses
  final candleSticks = <CandlestickSpot>[].obs;
  final minX = 0.0.obs;
  final maxX = 0.0.obs;
  final minY = 0.0.obs;
  final maxY = 0.0.obs;

  double _parseAmount(String raw) {
    final s = raw.trim().replaceAll(',', '.');
    return double.tryParse(s) ?? 0.0;
  }

  @override
  void onInit() {
    super.onInit();
    // Panggil semua data saat init
    _loadInitialData();
    fetchChartData(); // <-- Panggil data chart

    amountCtrl.addListener(() {
      amountRx.value = _parseAmount(amountCtrl.text);
    });
  }

  Future<void> _loadInitialData() async {
    // Panggil kedua fungsi secara bersamaan
    await Future.wait([loadBalance(), loadOwned(coin.name)]);
  }

  Future<void> loadBalance() async {
    try {
      userBalance.value = await userUsecase.getBalance();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat saldo: $e');
    }
  }

  Future<void> loadOwned(String coinName) async {
    try {
      ownedForCurrent.value = await userUsecase.getOwnedCoins(coinName);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kepemilikan koin: $e');
    }
  }

  // --- FUNGSI BARU UNTUK CHART ---
  void changeDays(String newDays) {
    if (newDays == selectedDays.value) return;
    selectedDays.value = newDays;
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      isChartLoading.value = true;

      // --- PERBAIKAN UNTUK MASALAH API KEY DEMO ---
      // API key demo tidak mendukung 'max'. Kita ganti 'max'
      // yang dipilih user menjadi request '365' hari (1 tahun).
      String daysToSend = selectedDays.value;
      if (daysToSend == 'max') {
        daysToSend = '365';
      }
      // --- BATAS PERBAIKAN ---

      // Panggil Usecase dengan 'daysToSend' yang sudah aman
      final chartDataPoints = await getCoinChartUsecase(
        coin.id,
        days: daysToSend,
      );

      if (chartDataPoints.isNotEmpty) {
        _processChartData(chartDataPoints);
      } else {
        // Handle jika data '365' juga kosong
        candleSticks.value = []; // Kosongkan chart
        Get.snackbar('Info', 'Data chart tidak tersedia untuk 1 tahun.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data chart: $e');
    } finally {
      isChartLoading.value = false;
    }
  }

  void _processChartData(List<dynamic> chartDataPoints) {
    double tempMinY = double.maxFinite;
    double tempMaxY = double.minPositive;

    // --- PERBAIKAN FINAL (baris 117) ---
    final List<CandlestickSpot> sticks = []; // <-- TIPE YANG BENAR

    for (int i = 0; i < chartDataPoints.length; i++) {
      final item = chartDataPoints[i];
      final double timestamp = (item[0] as num).toDouble();
      final double open = (item[1] as num).toDouble();
      final double high = (item[2] as num).toDouble();
      final double low = (item[3] as num).toDouble();
      final double close = (item[4] as num).toDouble();

      // --- PERBAIKAN FINAL (baris 130) ---
      // 'CandleStickSpot' ada di autocomplete kamu.
      // Error 'low' akan hilang karena constructor ini benar.
      sticks.add(
        CandlestickSpot(
          x: timestamp, // Sumbu X
          open: open,
          high: high,
          low: low,
          close: close,
        ),
      );

      if (low < tempMinY) tempMinY = low;
      if (high > tempMaxY) tempMaxY = high;
    }

    candleSticks.value = sticks; // Error tipe akan hilang
    minX.value = (chartDataPoints.first[0] as num).toDouble();
    maxX.value = (chartDataPoints.last[0] as num).toDouble();
    minY.value = tempMinY * 0.95; // 5% padding
    maxY.value = tempMaxY * 1.05; // 5% padding
  }

  // --- FUNGSI TRANSAKSI (TIDAK BERUBAH) ---
  Future<void> _executeTransaction(
    Future<void> Function() transactionFuture,
  ) async {
    final amount = amountRx.value;
    if (amount <= 0) {
      Get.snackbar('Amount tidak valid', 'Masukkan jumlah > 0');
      return;
    }

    isLoading.value = true;
    try {
      await transactionFuture();
      await _loadInitialData(); // Reload balance dan owned
      amountCtrl.clear();
      Get.snackbar('Sukses', 'Transaksi berhasil', colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Transaksi Gagal', e.toString(), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onBuy() async {
    await _executeTransaction(() => usecase.buyCoin(coin, amountRx.value));
  }

  Future<void> onSell() async {
    await _executeTransaction(() => usecase.sellCoin(coin, amountRx.value));
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    super.onClose();
  }
}
