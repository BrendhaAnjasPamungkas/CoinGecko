// ========== lib/app/data/repositories/coin_repository_impl.dart ==========
import 'package:blockchain/app/data/datasource/coin_datasource.dart';
import 'package:blockchain/app/data/models/coin_model.dart';
import 'package:blockchain/app/data/models/coin_search.dart';
import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/domain/entities/search.dart';
import 'package:blockchain/app/domain/repositories/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinDatasource datasource;

  CoinRepositoryImpl({required this.datasource});

  @override
  Future<List<Coin>> getMarketCoins() async {
    // 1. Ambil Model
    final List<CoinModel> coinModels = await datasource.getMarketCoins();
    
    // 2. Konversi ke Entity
    final List<Coin> coinEntities =
        coinModels.map((model) => model.toEntity()).toList();

    // 3. Kembalikan Entity (Error kamu akan hilang)
    return coinEntities;
  }

  @override
  Future<List<Search>> getSearch(String value) async {
    // 1. Ambil Model
    final List<SearchModel> searchModels = await datasource.getSearch(value);

    // 2. Konversi ke Entity
    final List<Search> searchEntities =
        searchModels.map((model) => model.toEntity()).toList();
    
    // 3. Kembalikan Entity (Ini akan memperbaiki error di UseCase kamu)
    return searchEntities;
  }

  @override
  Future<List<dynamic>> getCoinChartData(String coinId, String days) async {
    // Datasource sudah mengembalikan List<dynamic>, jadi tidak perlu konversi
    return await datasource.getCoinChartData(coinId, days);
  }
}