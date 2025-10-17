

import 'package:blockchain/app/data/models/coin_model.dart';
import 'package:blockchain/app/data/models/coin_search.dart';
import 'package:blockchain/app/datasource/coin_datasource.dart';
import 'package:blockchain/app/domain/entities/coin.dart';
import 'package:blockchain/app/domain/entities/search.dart';
import 'package:blockchain/app/domain/repositories/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinDatasource datasource;
  CoinRepositoryImpl({required this.datasource});

  @override
  Future<List<Coin>> getMarketCoins() async {
    List<CoinModel> listCoin = await datasource.getMarketCoins();
    return listCoin.map((e) {
      return e.toEntity();
    }).toList();
  }
    @override
    Future<List<Search>> getSearch(String value) async {
    List<SearchModel> listCoin = await datasource.getSearch(value);
    return listCoin.map((e) {
      return e.toEntity();
    }).toList();
  }
  
}
