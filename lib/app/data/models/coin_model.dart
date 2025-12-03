import 'package:blockchain/app/domain/entities/coin.dart';

class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final String currentPrice;
  final double priceChangePercentage24h;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json["id"],
      name: json["name"],
      symbol: json["symbol"],
      image: json["image"].toString(),
      currentPrice: json["current_price"].toString(),
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Coin toEntity() {
    return Coin(
      id: id,
      name: name,
      symbol: symbol,
      image: image,
      currentPrice: currentPrice,
      priceChangePercentage24h: priceChangePercentage24h,
    );
  }
}
