import 'dart:developer';

import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/repositories/market_chart_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MarketChartTimeInterval {
  all,
  oneYear,
  sixMonths,
  threeMonths,
  oneMonth,
  sevenDays,
  oneDay
}

enum MarketChartStateStatus { initial, loading, success, error, errorLoading }

class MarketChartState {
  final MarketChartStateStatus status;
  final MarketChartModel? marketChart;
  final String? errorMessage;

  MarketChartState._(
      {required this.status, this.marketChart, this.errorMessage});

  factory MarketChartState.initial() => MarketChartState._(
      status: MarketChartStateStatus.initial,
      marketChart: null,
      errorMessage: null);

  factory MarketChartState.loading(MarketChartModel? marketChart) =>
      MarketChartState._(
          status: MarketChartStateStatus.loading,
          marketChart: marketChart,
          errorMessage: null);

  factory MarketChartState.success(MarketChartModel? marketChart) =>
      MarketChartState._(
          status: MarketChartStateStatus.success,
          marketChart: marketChart,
          errorMessage: null);

  factory MarketChartState.error(String message) => MarketChartState._(
      status: MarketChartStateStatus.error,
      marketChart: null,
      errorMessage: message);

  factory MarketChartState.errorLoading(MarketChartModel? marketChart) =>
      MarketChartState._(
          status: MarketChartStateStatus.errorLoading,
          marketChart: marketChart,
          errorMessage: null);
}

class MarketChartNotifier extends StateNotifier<MarketChartState> {
  final MarketChartRepository repository;
  final Ref ref;
  final String coinId;

  MarketChartNotifier(this.ref,
      {required this.repository, required this.coinId})
      : super(MarketChartState.initial()) {
    initialFetch();
  }

  Future<void> initialFetch() async {
    try {
      await fetchMarketChart(coinId, MarketChartTimeInterval.oneMonth);
    } catch (e) {
      log('Error fetching coin market chart data for $coinId',
          error: e, stackTrace: StackTrace.current);
      state = MarketChartState.error('Error fetching coin market chart data');
    }
  }

  Future<void> reTryFetch() async {
    state = MarketChartState.initial();
    await initialFetch();
  }

  Future<void> fetchMarketChart(
      String id, MarketChartTimeInterval interval) async {
    final marketChart =
        await repository.getCoinMarketChart(id, interval, state.marketChart);
    state = MarketChartState.success(marketChart);
  }

  void setMarketChartDataType(MarketChartDataType type) {
    state.marketChart?.setType(type);
    state = MarketChartState.success(state.marketChart);
  }

  Future<void> onMarketChartTimeIntervalChanged(
      MarketChartTimeInterval interval) async {
    state = MarketChartState.loading(state.marketChart);
    try {
      await fetchMarketChart(coinId, interval);
    } catch (e) {
      log('Error fetching coin market chart data for $coinId',
          error: e, stackTrace: StackTrace.current);
      state = MarketChartState.errorLoading(state.marketChart);
    }
  }
}
