// ========== presentation/views/transaction_view.dart ==========
import 'package:blockchain/app/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/presentation/controllers/transaction_controller.dart';
import 'package:intl/intl.dart';

// Import injection.dart (get_it)
import 'package:blockchain/injection.dart';

// Import UseCases
import 'package:blockchain/app/domain/usecase/transaction_usecase.dart';
import 'package:blockchain/app/domain/usecase/user_usecase.dart';

// --- IMPORT BARU UNTUK CHART ---
import 'package:blockchain/app/domain/usecase/get_coin_chart_usecase.dart';
import 'package:fl_chart/fl_chart.dart';

class AddTransactionView extends StatelessWidget {
  final Coin coin;
  final TransactionController huda;

  // --- MODIFIKASI Get.put() ---
  AddTransactionView({super.key, required this.coin})
    : huda = Get.put(
        // 1. Buat Controller
        TransactionController(
          coin: coin,
          // 2. Inject dependensi (UseCase) dari GetIt (sl)
          usecase: sl<TransactionUseCase>(),
          userUsecase: sl<UserUsecase>(),
          // 3. Inject UseCase BARU untuk chart
          getCoinChartUsecase: sl<GetCoinChartUsecase>(),
        ),
        // 4. Beri TAG unik agar tidak crash saat buka koin berbeda
        tag: coin.id,
        // 5. Set 'permanent' ke false agar di-dispose saat halaman ditutup
        permanent: false,
      );

  // Helper untuk format mata uang
  String _formatCurrency(double value, {int decimalDigits = 2}) {
    // Tampilkan lebih banyak desimal untuk koin < $1
    if (value > 0 && value < 1) {
      decimalDigits = 6;
    }
    return NumberFormat.currency(
      decimalDigits: decimalDigits,
      locale: 'id_ID',
      symbol: '\$',
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    String currentPrice = coin.currentPrice;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: W.text(data: coin.name, color: Colors.white, fontSize: 18),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
      ),
      body: Container(
        // ... (Container dekorasi kamu)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0f172a), // slate-900
              Color(0xFF1e3a8a), // blue-900
              Color(0xFF1e293b), // slate-800
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // Tambahkan Obx untuk menampilkan loading spinner
        child: Obx(
          () => Stack(
            children: [
              // --- GANTI Column MENJADI ListView ---
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  W.gap(height: 70), // Ganti dari 70 ke 80 jika perlu
                  // --- WIDGET BARU: HEADER HARGA ---
                  _buildHeader(currentPrice),
                  W.gap(height: 24),

                  // --- WIDGET BARU: DAY SELECTOR ---
                  _buildDaySelector(),
                  W.gap(height: 16),

                  // --- WIDGET BARU: CHART ---
                  Container(
                    height: 250, // Beri tinggi tetap untuk chart
                    padding: const EdgeInsets.only(top: 16),
                    child: Obx(() {
                      if (huda.isChartLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (huda.candleSticks.isEmpty) {
                        return Center(
                          child: W.text(
                            data: 'Data chart tidak tersedia',
                            color: Colors.white70,
                          ),
                        );
                      }
                      return _buildChart();
                    }),
                  ),
                  W.gap(height: 24),

                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Obx(
                          // <-- Obx ini sudah benar
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              W.text(
                                data: "Saldo USD",
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              W.gap(height: 17),
                              W.text(
                                data:
                                    NumberFormat.currency(
                                      decimalDigits: 2,
                                      locale: 'id_ID',
                                      symbol: '\$',
                                    ).format(
                                      huda.userBalance.value,
                                    ), // <-- Sudah benar
                                color: Colors.white,
                              ),
                              W.gap(height: 4),
                              W.text(
                                data: "Tersedia untuk Trading",
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  W.gap(height: 30),

                  // ... (Sisa UI kamu - KODE ASLI)
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- KODE ASLI KAMU ---
                              W.text(
                                data: "Jenis Koin",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              W.gap(height: 9),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: W.text(
                                          data: coin.name,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      W.gap(width: 7),
                                      Expanded(
                                        child: W.text(
                                          data:
                                              "(${coin.symbol.toUpperCase()})",
                                          overflow: TextOverflow.ellipsis,
                                          color: const Color.fromARGB(
                                            255,
                                            219,
                                            219,
                                            219,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              W.gap(height: 16),
                              // --- KODE ASLI KAMU ---
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 18,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          W.text(
                                            data: "Harga Saat ini",
                                            color: const Color.fromARGB(
                                              255,
                                              186,
                                              186,
                                              186,
                                            ),
                                            fontSize: 12,
                                          ),
                                          W.gap(height: 4),
                                          W.text(
                                            // Panggil helper _formatCurrency
                                            data: _formatCurrency(
                                              double.tryParse(currentPrice) ??
                                                  0,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              W.gap(height: 18),
                              // --- KODE ASLI KAMU ---
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    85,
                                    109,
                                    242,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          W.text(
                                            data:
                                                "Balance (Kepemilikan)", // <-- Typo diperbaiki
                                            color: const Color.fromARGB(
                                              255,
                                              208,
                                              207,
                                              207,
                                            ),
                                          ),
                                          W.gap(height: 8),
                                          Obx(
                                            // <-- Sudah benar
                                            () => W.text(
                                              data:
                                                  "${NumberFormat.currency(decimalDigits: 8, locale: 'id_ID', symbol: '').format(huda.ownedForCurrent.value)} ${coin.symbol.toUpperCase()}", // <-- Symbol $ dihapus
                                              color: Colors.white,
                                            ),
                                          ),
                                          W.gap(height: 8),
                                          Obx(
                                            // --- LOGIKA DIPERBARUI ---
                                            () => W.text(
                                              data:
                                                  "= ${_formatCurrency((huda.ownedForCurrent.value) * (double.tryParse(currentPrice) ?? 0))}",
                                              color: const Color.fromARGB(
                                                255,
                                                240,
                                                240,
                                                240,
                                              ),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              W.gap(height: 24),
                              // --- KODE ASLI KAMU ---
                              TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Amount (Jumlah)',
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintText: '0.00000000',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF64748b), // slate-500
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(
                                    alpha: 0.05,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                                controller: huda.amountCtrl,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan jumlah';
                                  }
                                  return null;
                                },
                              ),

                              W.gap(height: 30),
                              // --- KODE ASLI KAMU ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: W.button(
                                      onPressed: () {
                                        final canTx = huda.amountRx.value > 0;
                                        // Nonaktifkan tombol jika loading
                                        (canTx && !huda.isLoading.value)
                                            ? huda.onBuy()
                                            : null; // Ganti debugPrint
                                      },
                                      child: W.text(
                                        data: "Buy",
                                        color: Colors.white,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        33,
                                        255,
                                        4,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  W.gap(height: 16, width: 10),
                                  Expanded(
                                    child: W.button(
                                      onPressed: () {
                                        final canTx = huda.amountRx.value > 0;
                                        // Nonaktifkan tombol jika loading
                                        (canTx && !huda.isLoading.value)
                                            ? huda.onSell()
                                            : null; // Ganti debugPrint
                                      },
                                      child: W.text(
                                        data: "Sell",
                                        color: Colors.white,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        232,
                                        15,
                                        0,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  W.gap(height: 30), // Padding di akhir list
                ],
              ),

              // --- KODE ASLI KAMU ---
              // Loading Indicator (untuk BUY/SELL)
              if (huda.isLoading.value)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER BARU: HEADER HARGA ---
  Widget _buildHeader(String currentPrice) {
    double price = double.tryParse(currentPrice) ?? 0.0;
    double change = coin.priceChangePercentage24h;
    bool isPriceUp = change >= 0;

    return Center(
      child: Column(
        children: [
          W.text(
            data: _formatCurrency(price),
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          W.gap(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPriceUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: isPriceUp ? Colors.greenAccent : Colors.redAccent,
              ),
              W.text(
                data: '${change.toStringAsFixed(2)}% (24j)',
                color: isPriceUp ? Colors.greenAccent : Colors.redAccent,
                fontSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER BARU: DAY SELECTOR ---
  Widget _buildDaySelector() {
    return SizedBox(
      width: Get.width,
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // Pusatkan selector jika ruang cukup
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: huda.dayOptions.length,
        separatorBuilder: (context, index) => W.gap(width: 12),
        itemBuilder: (context, index) {
          final days = huda.dayOptions[index];
          return Obx(() {
            final isSelected = huda.selectedDays.value == days;
            return ChoiceChip(
              label: W.text(
                data: days == 'max' ? 'All' : '${days}D',
                color: isSelected
                    ? Colors.black
                    : const Color.fromARGB(255, 0, 0, 0),
                fontSize: 12,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  huda.changeDays(days);
                }
              },
              selectedColor: Colors.blueAccent,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              padding: EdgeInsets.symmetric(horizontal: 8),
            );
          });
        },
      ),
    );
  }

  // --- WIDGET HELPER BARU: CHART ---
  Widget _buildChart() {
    return CandlestickChart(
      CandlestickChartData(
        // --- PERBAIKAN STRUKTUR ---
        // Semua 'titles' (sumbu) harus masuk ke dalam 'titlesData'
        titlesData: FlTitlesData(
          show: true, // Pastikan titlesData aktif
          // Sumbu Y (Kiri)
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  NumberFormat.compactCurrency(symbol: '\$').format(value),
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                );
              },
            ),
          ),

          // Sumbu X (Bawah)
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // (Mungkin perlu 'reservedSize' jika labelnya terpotong)
              // reservedSize: 22,
              getTitlesWidget: (value, meta) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(
                  value.toInt(),
                );
                String label = DateFormat('d MMM').format(date); // '5 Nov'
                return Text(
                  label,
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                );
              },
            ),
          ),

          // Sembunyikan sumbu lainnya
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        // --- BATAS PERBAIKAN ---

        // Style
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        // Data (Ini sudah benar)
        candlestickSpots: huda.candleSticks.toList(),
        minX: huda.minX.value,
        maxX: huda.maxX.value,
        minY: huda.minY.value,
        maxY: huda.maxY.value,
      ),
    );
  }
}
