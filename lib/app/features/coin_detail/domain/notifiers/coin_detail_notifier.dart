import 'dart:developer';

import 'package:cryptosight/app/features/coin_detail/data/models/coin_detail_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/repositories/coin_detail_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CoinDetailStateStatus { loading, success, error }

class CoinDetailState {
  final CoinDetailStateStatus status;
  final MarketChartDataModel? marketChartData;
  final CoinDetailModel? coinDetail;
  final String? errorMessage;

  CoinDetailState._(
      {required this.status,
      this.marketChartData,
      this.coinDetail,
      this.errorMessage});

  factory CoinDetailState.loading() => CoinDetailState._(
      status: CoinDetailStateStatus.loading,
      marketChartData: null,
      coinDetail: null,
      errorMessage: null);

  factory CoinDetailState.success(CoinDetailModel coinDetail,
          [MarketChartDataModel? marketChartData]) =>
      CoinDetailState._(
          status: CoinDetailStateStatus.success,
          marketChartData: marketChartData,
          coinDetail: coinDetail,
          errorMessage: null);

  factory CoinDetailState.error(String message) => CoinDetailState._(
      status: CoinDetailStateStatus.error,
      marketChartData: null,
      coinDetail: null,
      errorMessage: message);
}

class CoinDetailNotifier extends StateNotifier<CoinDetailState> {
  final CoinDetailRepository repository;
  final Ref ref;
  final String coinId;

  CoinDetailNotifier(this.ref, {required this.repository, required this.coinId})
      : super(CoinDetailState.loading()) {
    init();
  }

  Future<void> init() async {
    await fetchCoinDetail(coinId);
    await fetchCoinMarketChart(coinId, 1);
  }

  Future<void> fetchCoinDetail(String id) async {
    try {
      state = CoinDetailState.loading();
      final coinDetail = await repository.getCoinDetail(id);
      state = CoinDetailState.success(coinDetail);
    } catch (e) {
      log('Error fetching coin detail data for $id',
          error: e, stackTrace: StackTrace.current);
      state = CoinDetailState.error('Error fetching coin detail data');
    }
  }

  Future<void> fetchCoinMarketChart(String id, int days) async {
    try {
      final marketChartData = await repository.getCoinMarketChart(id, days);
      state = CoinDetailState.success(state.coinDetail!, marketChartData);
    } catch (e) {
      log('Error fetching coin market chart data for $id',
          error: e, stackTrace: StackTrace.current);
      state = CoinDetailState.error('Error fetching coin market chart data');
    }
  }
}
