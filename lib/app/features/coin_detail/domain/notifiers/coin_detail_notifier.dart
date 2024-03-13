import 'dart:developer';

import 'package:cryptosight/app/features/coin_detail/data/models/coin_detail_model.dart';
import 'package:cryptosight/app/features/coin_detail/data/repositories/coin_detail_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CoinDetailStateStatus { loading, success, error }

class CoinDetailState {
  final CoinDetailStateStatus status;
  final CoinDetailModel? coinDetail;
  final String? errorMessage;

  CoinDetailState._(
      {required this.status, required this.coinDetail, this.errorMessage});

  factory CoinDetailState.loading() => CoinDetailState._(
      status: CoinDetailStateStatus.loading,
      coinDetail: null,
      errorMessage: null);

  factory CoinDetailState.success(CoinDetailModel coinDetail) =>
      CoinDetailState._(
          status: CoinDetailStateStatus.success,
          coinDetail: coinDetail,
          errorMessage: null);

  factory CoinDetailState.error(String message) => CoinDetailState._(
      status: CoinDetailStateStatus.error,
      coinDetail: null,
      errorMessage: message);
}

class CoinDetailNotifier extends StateNotifier<CoinDetailState> {
  final CoinDetailRepository repository;
  final Ref ref;
  final String coinId;

  CoinDetailNotifier(this.ref, {required this.repository, required this.coinId})
      : super(CoinDetailState.loading()) {
    fetchCoinDetail(coinId);
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
}
