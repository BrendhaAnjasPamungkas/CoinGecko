import 'package:blockchain/app/domain/entities/search.dart';

import '../entities/coin.dart';
abstract class CoinRepository {
  Future<List<Coin>> getMarketCoins();
  Future<List<Search>> getSearch(String value);
}