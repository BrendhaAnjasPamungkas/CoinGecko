// ========== lib/app/domain/repositories/coin_repository.dart ==========
import 'package:blockchain/app/domain/entities/coin.dart';

import 'package:blockchain/app/domain/entities/search.dart';

// INI ADALAH INTERFACE (KONTRAK) MURNI
abstract class CoinRepository {
  Future<List<Coin>> getMarketCoins();
  Future<List<Search>> getSearch(String value);
  
  // FUNGSI BARU UNTUK CHART
  Future<List<dynamic>> getCoinChartData(String coinId, String days);
}