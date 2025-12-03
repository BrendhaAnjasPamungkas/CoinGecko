// ========== lib/app/domain/usecase/get_coin_chart_usecase.dart ==========
import 'package:blockchain/app/domain/repositories/coin_repository.dart';

class GetCoinChartUsecase {
  final CoinRepository repository;

  GetCoinChartUsecase(this.repository);

  // 'call' mengizinkan kita memanggil class ini sebagai fungsi
  // e.g. getCoinChartUsecase(coin.id, days: '7')
  Future<List<dynamic>> call(String coinId, {String days = '7'}) async {
    return await repository.getCoinChartData(coinId, days);
  }
}