
import 'dart:convert';

import 'package:blockchain/app/domain/entities/search.dart';

class SearchModel {
    final String id;
    final String name;
    final String apiSymbol;
    final String symbol;
    final int marketCapRank;
    final String thumb;
    final String large;

    SearchModel({
        required this.id,
        required this.name,
        required this.apiSymbol,
        required this.symbol,
        required this.marketCapRank,
        required this.thumb,
        required this.large,
    });

    factory SearchModel.fromJson(String str) => SearchModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SearchModel.fromMap(Map<String, dynamic> json) => SearchModel(
        id: json["id"],
        name: json["name"],
        apiSymbol: json["api_symbol"],
        symbol: json["symbol"],
        marketCapRank: json["market_cap_rank"],
        thumb: json["thumb"],
        large: json["large"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "api_symbol": apiSymbol,
        "symbol": symbol,
        "market_cap_rank": marketCapRank,
        "thumb": thumb,
        "large": large,
    };


  Search toEntity() {
    return Search(
      id: id,
      name: name,
      apiSymbol: apiSymbol,
      symbol: symbol,
      marketCapRank: marketCapRank,
      thumb: thumb,
      large: large
    );
  }
}
