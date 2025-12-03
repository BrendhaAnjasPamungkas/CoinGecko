import 'package:blockchain/app/domain/entities/coin.dart'; // <-- IMPORT COIN
import 'package:blockchain/app/domain/entities/search.dart';
import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blockchain/injection.dart';

class Searchkontrol extends GetxController {
  // UseCase kamu (saya asumsikan 'call()' mengambil market, 'call2()' mencari)
  final GetMarketCoinsUsecase searchUse = sl<GetMarketCoinsUsecase>();

  final TextEditingController textEditing = TextEditingController();

  // --- STATE BARU ---
  // State untuk daftar koin awal (Top 100)
  final RxList<Coin> initialCoins = <Coin>[].obs;
  // State untuk hasil pencarian
  final RxList<Search> searchResults = <Search>[].obs;

  // State untuk loading
  final isLoading = true.obs;
  // State untuk membedakan tampilan
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil daftar koin awal saat controller dibuat
    fetchInitialCoins();

    // Tambahkan listener untuk mendeteksi kapan search bar kosong
    textEditing.addListener(() {
      if (textEditing.text.isEmpty) {
        // Jika user menghapus teks, kembali ke daftar awal
        isSearching.value = false;
        searchResults.clear(); // Hapus hasil search sebelumnya
      } else {
        // Jika user mulai mengetik, aktifkan mode pencarian
        isSearching.value = true;
      }
    });
  }

  @override
  void onClose() {
    textEditing.dispose();
    super.onClose();
  }

  // --- FUNGSI BARU ---
  // Mengambil daftar koin awal (Top 100)
  Future<void> fetchInitialCoins() async {
    try {
      isLoading.value = true;
      // Asumsi 'call()' adalah fungsi yang mengambil List<Coin>
      initialCoins.value = await searchUse.call();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar koin: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI LAMA (DIMODIFIKASI) ---
  // Mengambil hasil pencarian
  Future<void> getSer() async {
    if (textEditing.text.isEmpty) return;

    isSearching.value = true;
    isLoading.value = true; // Gunakan loading state yang sama
    
    try {
      // Asumsi 'call2()' adalah fungsi yang mengambil List<Search>
      searchResults.value = await searchUse.call2(textEditing.text);
    } catch (e) {
      Get.snackbar('Error', 'Gagal melakukan pencarian: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Coin? findCoinFromSearch(Search searchResult) {
    try {
      // Cari di 'initialCoins' di mana id-nya sama
      return initialCoins.firstWhere(
        (coin) => coin.id.toLowerCase() == searchResult.id.toLowerCase(),
      );
    } catch (e) {
      // 'firstWhere' akan error jika tidak ketemu, kita tangkap
      return null;
    }
  }

}
