class MarketChartDataModel {
  final List<List<num>> prices;
  final List<List<num>>? marketCaps;
  final List<List<num>>? totalVolumes;

  MarketChartDataModel({
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

  List<Map<String, num>> get pricesMap {
    return prices.map((e) => {'date': e[0], 'price': e[1]}).toList();
  }

  List<Map<String, num>>? get marketCapsMap {
    return marketCaps?.map((e) => {'date': e[0], 'marketCap': e[1]}).toList();
  }

  List<Map<String, num>>? get totalVolumesMap {
    return totalVolumes
        ?.map((e) => {'date': e[0], 'totalVolume': e[1]})
        .toList();
  }
}
