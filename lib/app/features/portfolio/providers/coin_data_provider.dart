import 'package:cryptosight/app/features/market_cap/providers/market_cap_provider.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/coin_data_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinDataNotifierProvider =
    StateNotifierProvider<CoinDataNotifier, CoinDataState>(
  (ref) => CoinDataNotifier(repository: ref.watch(marketCapRepositoryProvider)),
);
