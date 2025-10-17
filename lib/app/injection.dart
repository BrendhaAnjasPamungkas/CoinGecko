import 'package:blockchain/app/data/repositories/coin_repository_impl.dart';
import 'package:blockchain/app/datasource/coin_datasource.dart';
import 'package:blockchain/app/domain/repositories/coin_repository.dart';
import 'package:blockchain/app/domain/usecase/get_market_coins_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton(() {
    return http.Client();
  });

  sl.registerLazySingleton((){
    return CoinDatasource(client: sl());

  });

  sl.registerLazySingleton<CoinRepository>((){
    return CoinRepositoryImpl(datasource: sl());
  });

  sl.registerLazySingleton((){
    return GetMarketCoinsUsecase(sl());
  });
}
