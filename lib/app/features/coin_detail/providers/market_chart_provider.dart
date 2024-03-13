import 'package:cryptosight/app/features/coin_detail/data/repositories/market_chart_repository.dart';
import 'package:cryptosight/app/features/coin_detail/domain/notifiers/market_chart_notifier.dart';
import 'package:cryptosight/app/features/coin_detail/providers/coin_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketChartRepositoryProvider = Provider<MarketChartRepository>((ref) {
  final apiService = ref.read(marketApiServiceProvider);
  return MarketChartRepository(marketApiService: apiService);
});

final marketChartNotifierProvider = StateNotifierProvider.family<MarketChartNotifier, MarketChartState, String>(
  (ref, coinId) {
    final repository = ref.read(marketChartRepositoryProvider);
    return MarketChartNotifier(ref, repository: repository, coinId: coinId);
  },
);