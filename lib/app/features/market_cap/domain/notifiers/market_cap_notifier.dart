import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/app/features/market_cap/data/repositories/market_cap_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MarketCapStateStatus { loading, success, error }

class MarketCapState {
  final MarketCapStateStatus status;
  final List<CoinMarketDataModel>? marketCap;
  final String? errorMessage;

  MarketCapState({required this.status, this.marketCap, this.errorMessage});

  factory MarketCapState.loading() => MarketCapState(
      status: MarketCapStateStatus.loading,
      marketCap: null,
      errorMessage: null);

  factory MarketCapState.success(List<CoinMarketDataModel> marketCap) =>
      MarketCapState(
          status: MarketCapStateStatus.success,
          marketCap: marketCap,
          errorMessage: null);

  factory MarketCapState.error(String message) => MarketCapState(
      status: MarketCapStateStatus.error,
      marketCap: null,
      errorMessage: message);
}

class MarketCapNotifier extends StateNotifier<MarketCapState> {
  final MarketCapRepository repository;
  final Ref ref;

  MarketCapNotifier(this.ref, {required this.repository})
      : super(MarketCapState.loading()) {
    fetchMarketCap();
  }

  Future<void> fetchMarketCap() async {
    try {
      state = MarketCapState.loading();
      final marketCap = await repository.getMarketCap();
      state = MarketCapState.success(marketCap);
    } catch (e) {
      state = MarketCapState.error('Error fetching market cap data');
    }
  }
}
