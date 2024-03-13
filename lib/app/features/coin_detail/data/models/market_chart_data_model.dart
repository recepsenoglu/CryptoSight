import 'package:cryptosight/app/features/coin_detail/domain/notifiers/coin_detail_notifier.dart';

enum MarketChartDataType { prices, marketCaps, totalVolumes }

enum MarketChartDataGranularity { fiveMinutely, hourly, daily }

class MarketChartModel {
  MarketChartDataType type;
  MarketChartTimeInterval timeInterval;
  final List<MarketChartDataModel> _marketChartData;

  MarketChartModel({
    this.type = MarketChartDataType.prices,
    required this.timeInterval,
    required MarketChartDataModel marketChartData,
  }) : _marketChartData = [marketChartData];

  MarketChartDataModel get marketChartData {
    return _marketChartData.firstWhere(
      (element) =>
          element.granularity == timeIntervalToGranularity(timeInterval),
      orElse: () => _marketChartData.first,
    );
  }

  static MarketChartDataGranularity timeIntervalToGranularity(
      MarketChartTimeInterval timeInterval) {
    switch (timeInterval) {
      case MarketChartTimeInterval.all:
      case MarketChartTimeInterval.oneYear:
      case MarketChartTimeInterval.sixMonths:
        return MarketChartDataGranularity.daily;
      case MarketChartTimeInterval.threeMonths:
      case MarketChartTimeInterval.oneMonth:
      case MarketChartTimeInterval.sevenDays:
        return MarketChartDataGranularity.hourly;
      case MarketChartTimeInterval.oneDay:
        return MarketChartDataGranularity.fiveMinutely;
    }
  }

  void setType(MarketChartDataType type) {
    this.type = type;
  }

  void setTimeInterval(MarketChartTimeInterval timeInterval) {
    this.timeInterval = timeInterval;
  }

  void addMarketChartData(MarketChartDataModel marketChartData) {
    _marketChartData.add(marketChartData);
  }

  bool hasGranularity(MarketChartDataGranularity granularity) {
    return _marketChartData
        .any((element) => element.granularity == granularity);
  }
}

class MarketChartDataModel {
  MarketChartDataGranularity? granularity;
  final List<List<num>> prices;
  final List<List<num>> marketCaps;
  final List<List<num>> totalVolumes;

  MarketChartDataModel({
    this.granularity,
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

  List<List<num>> getData(
      MarketChartDataType type, MarketChartTimeInterval timeInterval) {
    final List<List<num>> data = type == MarketChartDataType.prices
        ? prices
        : type == MarketChartDataType.marketCaps
            ? marketCaps
            : totalVolumes;

    final minTimestamp = DateTime.now()
        .subtract(timeIntervalToDuration(timeInterval))
        .millisecondsSinceEpoch;

    final newData = data
        .where((element) => element[0] >= minTimestamp)
        .toList(growable: false);
    return newData;
  }

  Duration timeIntervalToDuration(MarketChartTimeInterval timeInterval) {
    switch (timeInterval) {
      case MarketChartTimeInterval.all:
        return Duration(days: 365 * 10);
      case MarketChartTimeInterval.oneYear:
        return Duration(days: 365);
      case MarketChartTimeInterval.sixMonths:
        return Duration(days: 30 * 6);
      case MarketChartTimeInterval.threeMonths:
        return Duration(days: 30 * 3);
      case MarketChartTimeInterval.oneMonth:
        return Duration(days: 30);
      case MarketChartTimeInterval.sevenDays:
        return Duration(days: 7);
      case MarketChartTimeInterval.oneDay:
        return Duration(days: 1);
    }
  }
}
