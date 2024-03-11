import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/services/market_api_service.dart';

class MarketCapRepository {
  final MarketApiService apiService;

  MarketCapRepository({required this.apiService});

  Future<List<CoinMarketDataModel>> getMarketCap() async {
    final rawData = await apiService.fetchMarketCap();
    return List<CoinMarketDataModel>.from(
        rawData.map((json) => CoinMarketDataModel.fromJson(json)));
  }
}