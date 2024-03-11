
import 'package:cryptosight/app/features/coin_detail/data/repositories/coin_detail_repository.dart';
import 'package:cryptosight/app/features/coin_detail/domain/notifiers/coin_detail_notifier.dart';
import 'package:cryptosight/services/market_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketApiServiceProvider = Provider<MarketApiService>((ref) {
  return MarketApiService();
});

final coinDetailRepositoryProvider = Provider<CoinDetailRepository>((ref) {
  final apiService = ref.read(marketApiServiceProvider);
  return CoinDetailRepository(marketApiService: apiService);
});

final coinDetailNotifierProvider = StateNotifierProvider.family<CoinDetailNotifier, CoinDetailState, String>(
  (ref, coinId) {
    final repository = ref.read(coinDetailRepositoryProvider);
    return CoinDetailNotifier(ref, repository: repository, coinId: coinId);
  },
);
