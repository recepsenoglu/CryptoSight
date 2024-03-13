import 'package:cryptosight/app/features/coin_detail/data/models/coin_detail_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/domain/notifiers/coin_detail_notifier.dart';
import 'package:cryptosight/services/market_api_service.dart';

class CoinDetailRepository {
  final MarketApiService marketApiService;

  CoinDetailRepository({required this.marketApiService});

  Future<CoinDetailModel> getCoinDetail(String id) async {
    final rawData = await marketApiService.fetchCoinData(id);
    return CoinDetailModel.fromJson(rawData);
  }

  Future<MarketChartModel> getCoinMarketChart(
      String id,
      MarketChartTimeInterval timeInterval,
      MarketChartModel? marketChartModel) async {
    if (marketChartModel != null) {
      marketChartModel.setTimeInterval(timeInterval);
      if (!marketChartModel.hasGranularity(
          MarketChartModel.timeIntervalToGranularity(timeInterval))) {
        final marketChartData =
            await _fetchCoinMarketChartData(id, timeInterval);
        marketChartData.granularity =
            MarketChartModel.timeIntervalToGranularity(timeInterval);
        marketChartModel.addMarketChartData(marketChartData);
      }
      return marketChartModel;
    }
    final marketChartData = await _fetchCoinMarketChartData(id, timeInterval);
    marketChartData.granularity = _calculateGranularity(timeInterval);
    final marketChart = MarketChartModel(
      timeInterval: timeInterval,
      marketChartData: marketChartData,
    );

    return marketChart;
  }

  Future<MarketChartDataModel> _fetchCoinMarketChartData(
      String id, MarketChartTimeInterval timeInterval) async {
    final rawData = await marketApiService.fetchCoinMarketChart(
        id, _calculateDays(timeInterval));
    return MarketChartDataModel.fromJson(rawData);
  }

  int _calculateDays(MarketChartTimeInterval timeInterval) {
    if (timeInterval == MarketChartTimeInterval.all ||
        timeInterval == MarketChartTimeInterval.oneYear ||
        timeInterval == MarketChartTimeInterval.sixMonths) {
      return 1000;
    }
    if (timeInterval == MarketChartTimeInterval.threeMonths ||
        timeInterval == MarketChartTimeInterval.oneMonth ||
        timeInterval == MarketChartTimeInterval.sevenDays) {
      return 90;
    }
    return 1;
  }

  MarketChartDataGranularity _calculateGranularity(
      MarketChartTimeInterval timeInterval) {
    if (timeInterval == MarketChartTimeInterval.all ||
        timeInterval == MarketChartTimeInterval.oneYear ||
        timeInterval == MarketChartTimeInterval.sixMonths) {
      return MarketChartDataGranularity.daily;
    }
    if (timeInterval == MarketChartTimeInterval.threeMonths ||
        timeInterval == MarketChartTimeInterval.oneMonth ||
        timeInterval == MarketChartTimeInterval.sevenDays) {
      return MarketChartDataGranularity.hourly;
    }
    return MarketChartDataGranularity.fiveMinutely;
  }
}
