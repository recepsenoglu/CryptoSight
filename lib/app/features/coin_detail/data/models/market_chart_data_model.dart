enum MarketChartDataType { prices, marketCaps, totalVolumes }

class MarketChartDataModel {
  MarketChartDataType type;
  final List<List<num>> prices;
  final List<List<num>> marketCaps;
  final List<List<num>> totalVolumes;

  MarketChartDataModel({
    this.type = MarketChartDataType.prices,
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });

  factory MarketChartDataModel.fromJson(Map<String, dynamic> json) {
    return MarketChartDataModel(
      prices: List<List<num>>.from(
          json['prices'].map((x) => List<num>.from(x.map((x) => x)))),
      marketCaps: List<List<num>>.from(
          json['market_caps'].map((x) => List<num>.from(x.map((x) => x)))),
      totalVolumes: List<List<num>>.from(
          json['total_volumes'].map((x) => List<num>.from(x.map((x) => x)))),
    );
  }

  List<List<num>> get data {
    switch (type) {
      case MarketChartDataType.prices:
        return prices;
      case MarketChartDataType.marketCaps:
        return marketCaps;
      case MarketChartDataType.totalVolumes:
        return totalVolumes;
    }
  }

  void setType(MarketChartDataType type) {
    this.type = type;
  }
}
