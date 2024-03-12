import 'package:cryptosight/app/features/coin_detail/data/models/coin_detail_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/services/market_api_service.dart';

class CoinDetailRepository {
  final MarketApiService marketApiService;

  CoinDetailRepository({required this.marketApiService});

  Future<CoinDetailModel> getCoinDetail(String id) async {
    final rawData = await marketApiService.fetchCoinData(id);
    return CoinDetailModel.fromJson(rawData);
  }

  Future<MarketChartDataModel> getCoinMarketChart(String id, int days) async {
    final rawData = await marketApiService.fetchCoinMarketChart(id, days);
    return MarketChartDataModel.fromJson(rawData);
  }
}
