// CoinDataState.dart
import 'dart:developer';

import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/app/features/market_cap/data/repositories/market_cap_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CoinDataStateStatus { initial, loading, success, error }

class CoinDataState {
  final CoinDataStateStatus status;
  final List<CoinSimpleDataModel>? coinData;
  final String? errorMessage;

  const CoinDataState({
    required this.status,
    this.coinData,
    this.errorMessage,
  });

  factory CoinDataState.initial() =>
      const CoinDataState(status: CoinDataStateStatus.initial);

  factory CoinDataState.loading() =>
      const CoinDataState(status: CoinDataStateStatus.loading);

  factory CoinDataState.success(List<CoinSimpleDataModel> data) =>
      CoinDataState(
        status: CoinDataStateStatus.success,
        coinData: data,
      );

  factory CoinDataState.error(String message) => CoinDataState(
        status: CoinDataStateStatus.error,
        errorMessage: message,
      );
}

class CoinDataNotifier extends StateNotifier<CoinDataState> {
  final MarketCapRepository repository;

  CoinDataNotifier({required this.repository}) : super(CoinDataState.initial());

  Future<void> fetchCoinData() async {
    state = CoinDataState.loading();
    try {
      final data = await repository.getSimpleMarketData();
      state = CoinDataState.success(data);
    } catch (e) {
      log('Error fetching coin data', error: e.toString());
      state = CoinDataState.error(e.toString());
    }
  }
}
