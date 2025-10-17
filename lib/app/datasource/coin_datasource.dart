import 'dart:convert';

import 'package:blockchain/app/data/models/coin_model.dart';
import 'package:blockchain/app/data/models/coin_search.dart';
import 'package:http/http.dart' as http;

class CoinDatasource {
  final http.Client client;
  CoinDatasource({required this.client});

  Future<List<CoinModel>> getMarketCoins() async {
    final response = await client.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&names=Bitcoin&symbols=btc&category=layer-1&price_change_percentage=1h',
      ),
      headers: {
        'Authorization': 'x-cg-demo-api-key: CG-7GN6MKHEwXBjKUFfECkWGvha',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      final coinList = jsonResponse
          .map((json) => CoinModel.fromJson(json))
          .toList();
      return coinList;
    } else {
      throw Exception("gagal memuat data API");
    }
  }

  Future<List<SearchModel>> getSearch(String value) async {
    final response = await client.get(
      Uri.parse("https://api.coingecko.com/api/v3/search?query=$value"),
      headers: {
        'Authorization': 'x-cg-demo-api-key:CG-7GN6MKHEwXBjKUFfECkWGvha',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> vaResponse = jsonDecode(response.body);
      List<dynamic> jsonResponse = vaResponse['coins'];
      final coinSearch = jsonResponse
          .map((json) => SearchModel.fromMap(json))
          .toList();
      return coinSearch;
    } else {
      throw Exception("gagal memuat data API");
    }
  }
}
