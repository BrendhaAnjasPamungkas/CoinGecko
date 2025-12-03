import 'package:blockchain/app/domain/entities/search.dart';

import '../entities/coin.dart';
import '../repositories/coin_repository.dart';

class GetMarketCoinsUsecase {
  final CoinRepository repository;
  
  GetMarketCoinsUsecase(this.repository);

  Future<List<Coin>> call() {
    return repository.getMarketCoins();
  }

  Future<List<Search>> call2(String value) {
    return repository.getSearch(value);
  }
}
