
import 'package:cryptosight/app/features/market_cap/data/repositories/market_cap_repository.dart';
import 'package:cryptosight/app/features/market_cap/domain/notifiers/market_cap_notifier.dart';
import 'package:cryptosight/services/market_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketApiServiceProvider = Provider<MarketApiService>((ref) {
  return MarketApiService();
});

final marketCapRepositoryProvider = Provider<MarketCapRepository>((ref) {
  final apiService = ref.read(marketApiServiceProvider);
  return MarketCapRepository(apiService: apiService);
});

final marketCapNotifierProvider = StateNotifierProvider<MarketCapNotifier, MarketCapState>((ref) {
  final repository = ref.watch(marketCapRepositoryProvider);
  return MarketCapNotifier(ref, repository: repository);
});