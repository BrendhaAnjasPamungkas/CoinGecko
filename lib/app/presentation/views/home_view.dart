import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/presentation/controllers/auth_controller.dart';
import 'package:blockchain/app/presentation/controllers/home_controller.dart';
import 'package:blockchain/app/presentation/views/search_view.dart';
import 'package:blockchain/app/presentation/views/transaction_view.dart';
import 'package:blockchain/app/presentation/views/wallet_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// Import controller wallet agar kita bisa menghapusnya
import 'package:blockchain/app/presentation/controllers/wallet_controller.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  // --- MODIFIKASI: Tambahkan permanent: false ---
  // Ini mencegah error GlobalKey saat hot restart, sama seperti di SearchView
  final HomeController kontroller = Get.put(HomeController(), permanent: false);
  final AuthController akont = Get.put(AuthController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: Get.width,
        actions: [
          IconButton(
            // --- MODIFIKASI: Tambahkan Get.delete ---
            // Ini sangat penting untuk menghapus state saldo
            // dari user sebelumnya SEBELUM logout
            onPressed: () {
              // Hapus controller wallet (dan saldo lamanya)
              Get.delete<WalletController>();
              // Panggil fungsi logout asli
              akont.logout();
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // --- MODIFIKASI: Gunakan () => ---
              // Cara yang lebih aman untuk navigasi dengan pola Get.put()
              Get.to(() => SearchView());
            },
            icon: Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            // --- MODIFIKASI: Tambahkan Get.delete untuk Auto-Refresh ---
            onPressed: () {
              // 1. Hapus controller lama dari memori
              Get.delete<WalletController>();
              // 2. Navigasi ke view. Ini akan memaksa Get.put()
              //    di WalletView untuk membuat controller BARU.
              Get.to(() => WalletView());
            },
            icon: Icon(Icons.wallet, color: Colors.white),
          ),
        ],
      ),
      body: Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Tambahkan jarak agar tidak tertimpa AppBar
              SizedBox(height: kToolbarHeight + Get.mediaQuery.padding.top), 
              Obx(() {
                // Tampilkan loading jika koin belum ada
                if (kontroller.koin.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                // Tampilkan list jika koin sudah ada
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: kontroller.koin.length,
                  itemBuilder: (context, index) {
                    final Coin koinData = kontroller.koin[index];
                    return Card(
                      color: Colors.white12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                      child: ListTile(
                        leading: Image.network(koinData.image),
                        title: Text(
                          koinData.symbol.toUpperCase(), // Ubah ke Uppercase
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          koinData.name,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        trailing: Text(
                          // Format harga agar lebih rapi
                          NumberFormat.currency(locale: 'id_ID', symbol: '\$')
                              .format(double.tryParse(koinData.currentPrice) ?? 0),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Navigasi ini sudah benar
                          Get.to(
                            () => AddTransactionView(coin: koinData),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}