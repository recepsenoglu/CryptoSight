class CoinSimpleDataModel {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  double amount;

  CoinSimpleDataModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    this.amount = 0,
  });

  factory CoinSimpleDataModel.fromJson(Map<String, dynamic> json) {
    return CoinSimpleDataModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: json['current_price'].toDouble(),
    );
  }
}
