import 'dart:developer';

import 'package:cryptosight/app/features/coin_detail/data/models/coin_detail_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/repositories/coin_detail_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CoinDetailStateStatus { loading, success, error }

enum MarketChartTimeInterval {
  all,
  oneYear,
  sixMonths,
  threeMonths,
  oneMonth,
  sevenDays,
  oneDay
}

class CoinDetailState {
  final CoinDetailStateStatus status;
  final MarketChartModel? marketChart;
  final CoinDetailModel? coinDetail;
  final String? errorMessage;

  CoinDetailState._(
      {required this.status,
      this.marketChart,
      this.coinDetail,
      this.errorMessage});

  factory CoinDetailState.loading() => CoinDetailState._(
      status: CoinDetailStateStatus.loading,
      marketChart: null,
      coinDetail: null,
      errorMessage: null);

  factory CoinDetailState.success(CoinDetailModel coinDetail,
          [MarketChartModel? marketChart]) =>
      CoinDetailState._(
          status: CoinDetailStateStatus.success,
          marketChart: marketChart,
          coinDetail: coinDetail,
          errorMessage: null);

  factory CoinDetailState.error(String message) => CoinDetailState._(
      status: CoinDetailStateStatus.error,
      marketChart: null,
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
    await fetchCoinMarketChart(coinId, MarketChartTimeInterval.oneMonth);
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

  Future<void> fetchCoinMarketChart(
      String id, MarketChartTimeInterval interval) async {
    try {
      final marketChart =
          await repository.getCoinMarketChart(id, interval, state.marketChart);
      state = CoinDetailState.success(state.coinDetail!, marketChart);
    } catch (e) {
      log('Error fetching coin market chart data for $id',
          error: e, stackTrace: StackTrace.current);
      state = CoinDetailState.error('Error fetching coin market chart data');
    }
  }

  void setMarketChartDataType(MarketChartDataType type) {
    state.marketChart!.setType(type);
    state = CoinDetailState.success(state.coinDetail!, state.marketChart);
  }

  Future<void> onMarketChartTimeIntervalChanged(
      MarketChartTimeInterval interval) async {
    await fetchCoinMarketChart(coinId, interval);
  }
}
