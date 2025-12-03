class Coin {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final String currentPrice;
  final double priceChangePercentage24h;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });
}
