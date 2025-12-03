import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/domain/entities/search.dart';
import 'package:blockchain/app/main_widget.dart';
import 'package:blockchain/app/presentation/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // <-- Import intl untuk format harga

// Import halaman transaksi
import 'package:blockchain/app/presentation/views/transaction_view.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  // --- MODIFIKASI 1 ---
  // Menambahkan 'permanent: false' untuk memperbaiki error GlobalKey
  final kontrl = Get.put(
    Searchkontrol(),
    permanent: false,
  );

  @override
  Widget build(BuildContext) {
    // ... (Scaffold, AppBar, dan body Container kamu tidak berubah)
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: kontrl.textEditing,
          // Otomatis panggil search saat user menekan 'search' di keyboard
          onSubmitted: (_) => kontrl.getSer(),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white, // warna kursor
          decoration: const InputDecoration(
            isDense: true,
            hintText: 'Cari...',
            hintStyle: TextStyle(color: Colors.white70), // warna hint
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: kontrl.getSer,
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        // Gunakan SafeArea agar list tidak tertimpa app bar
        child: SafeArea(
          child: Obx(
            () {
              // Tampilkan loading indicator
              if (kontrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Tampilkan daftar berdasarkan state 'isSearching'
              if (kontrl.isSearching.value) {
                // Tampilkan hasil pencarian (List<Search>)
                return _buildSearchList(kontrl.searchResults);
              } else {
                // Tampilkan daftar koin awal (List<Coin>)
                return _buildInitialList(kontrl.initialCoins);
              }
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGET INI TIDAK BERUBAH ---
  // Untuk menampilkan daftar koin awal (List<Coin>)
  Widget _buildInitialList(List<Coin> coins) {
    if (coins.isEmpty) {
      return Center(
          child: W.text(data: 'Tidak ada koin ditemukan', color: Colors.white70));
    }
    return ListView.builder(
      itemCount: coins.length,
      itemBuilder: (context, index) {
        final Coin coin = coins[index];
        return _buildCoinTile(coin);
      },
    );
  }

  // --- WIDGET INI TIDAK BERUBAH ---
  // Tile untuk satu koin (bisa diklik)
  Widget _buildCoinTile(Coin coin) {
    double price = double.tryParse(coin.currentPrice) ?? 0.0;
    double change = coin.priceChangePercentage24h;
    bool isPriceUp = change >= 0;

    return Card(
      color: Colors.white.withOpacity(0.05),
      child: ListTile(
        leading: Image.network(coin.image, width: 35, height: 35),
        title: W.text(
          data: coin.name,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 17,
        ),
        subtitle: W.text(data: coin.symbol.toUpperCase(), color: Colors.white70),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            W.text(
              data: NumberFormat.currency(locale: 'id_ID', symbol: '\$')
                  .format(price),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            W.text(
              data: '${change.toStringAsFixed(2)}%',
              color: isPriceUp ? Colors.greenAccent : Colors.redAccent,
            ),
          ],
        ),
        // --- FUNGSI KLIK ---
        onTap: () {
          Get.to(
            () => AddTransactionView(coin: coin),
            transition: Transition.rightToLeft,
          );
        },
      ),
    );
  }

  // --- MODIFIKASI 2 ---
  // Menambahkan onTap pada ListTile di dalam _buildSearchList
  Widget _buildSearchList(List<Search> searchResults) {
    if (searchResults.isEmpty) {
      return Center(
          child: W.text(data: 'Hasil pencarian kosong', color: Colors.white70));
    }
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final Search serc = searchResults[index];
        return Card(
          color: const Color.fromARGB(255, 4, 76, 121),
          child: ListTile(
            leading: Image.network(serc.thumb, scale: 0.7),
            title: W.text(
              data: serc.symbol,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 17,
            ),
            subtitle: W.text(data: serc.name, color: Colors.white),
            trailing: W.text(data: serc.apiSymbol, color: Colors.white),
            
            // --- FUNGSI KLIK BARU DITAMBAHKAN ---
            onTap: () {
              // 1. Panggil helper controller untuk mencari data koin lengkap
              final Coin? fullCoinData = kontrl.findCoinFromSearch(serc);

              // 2. Cek apakah koinnya ketemu
              if (fullCoinData != null) {
                // Jika ketemu (ada di Top 100), navigasi
                Get.to(
                  () => AddTransactionView(coin: fullCoinData),
                  transition: Transition.rightToLeft,
                );
              } else {
                // Jika tidak ketemu (tidak ada di Top 100)
                Get.snackbar(
                  'Data Tidak Lengkap',
                  'Info harga untuk koin ini tidak tersedia di daftar utama.',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            },
            // --- BATAS MODIFIKASI ---
          ),
        );
      },
    );
  }
}