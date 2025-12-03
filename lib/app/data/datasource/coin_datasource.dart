// ========== lib/app/data/datasource/coin_datasource.dart ==========
import 'dart:convert';
import 'package:blockchain/app/data/models/coin_model.dart';
import 'package:blockchain/app/data/models/coin_search.dart';
import 'package:http/http.dart' as http;

class CoinDatasource {
  final http.Client client;

  // --- PERBAIKAN: Pisahkan Base URL dan API Key ---
  final String _baseUrl = 'https://api.coingecko.com/api/v3';
  final String _apiKey = 'CG-7GN6MKHEwXBjKUFfECkWGvha';
  
  // Buat satu map headers untuk dipakai di semua request
  Map<String, String> get _headers => {
    'accept': 'application/json',
    'x-cg-demo-api-key': _apiKey,
  };

  CoinDatasource({required this.client});

  Future<List<CoinModel>> getMarketCoins() async {
    // --- PERBAIKAN: URL ini salah, seharusnya mengambil list market ---
    final response = await client.get(
      Uri.parse(
        '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false',
      ),
      headers: _headers, // Gunakan headers yang benar
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      final coinList =
          jsonResponse.map((json) => CoinModel.fromJson(json)).toList();
      return coinList;
    } else {
      throw Exception("gagal memuat data API market");
    }
  }

  Future<List<SearchModel>> getSearch(String value) async {
    final response = await client.get(
      Uri.parse("$_baseUrl/search?query=$value"),
      headers: _headers, // Gunakan headers yang benar
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> vaResponse = jsonDecode(response.body);
      List<dynamic> jsonResponse = vaResponse['coins'];
      final coinSearch =
          jsonResponse.map((json) => SearchModel.fromMap(json)).toList();
      return coinSearch;
    } else {
      throw Exception("gagal memuat data API search");
    }
  }

  // --- FUNGSI BARU UNTUK CHART ---
  Future<List<dynamic>> getCoinChartData(String coinId, String days) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/coins/$coinId/ohlc?vs_currency=usd&days=$days'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      // Data ini adalah list [timestamp, open, high, low, close]
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Gagal memuat data chart');
    }
  }
}