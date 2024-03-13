import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/domain/notifiers/market_chart_notifier.dart';
import 'package:cryptosight/services/market_api_service.dart';

class MarketChartRepository {
  final MarketApiService marketApiService;

  MarketChartRepository({required this.marketApiService});

  Future<MarketChartModel> getCoinMarketChart(
      String id,
      MarketChartTimeInterval timeInterval,
      MarketChartModel? marketChartModel) async {
    if (marketChartModel != null) {
      if (!marketChartModel.hasGranularity(
          MarketChartModel.timeIntervalToGranularity(timeInterval))) {
        final marketChartData =
            await _fetchCoinMarketChartData(id, timeInterval);
        marketChartData.granularity =
            MarketChartModel.timeIntervalToGranularity(timeInterval);
        marketChartModel.addMarketChartData(marketChartData);
      }
      
      marketChartModel.setTimeInterval(timeInterval);
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
