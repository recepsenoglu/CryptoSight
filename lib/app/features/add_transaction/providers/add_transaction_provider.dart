import 'package:cryptosight/app/features/add_transaction/domain/notifiers/add_transaction_notifier.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/app/features/portfolio/providers/portfolio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addTransactionProvider = StateNotifierProvider.family<
    AddTransactionNotifier, AddTransactionState, CoinSimpleDataModel>(
  (ref, coin) {
    return AddTransactionNotifier(
        repository: ref.read(portfolioRepositoryProvider), coin: coin);
  },
);
