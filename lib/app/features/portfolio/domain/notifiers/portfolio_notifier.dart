import 'dart:developer';

import 'package:cryptosight/app/features/portfolio/data/models/portfolio_model.dart';
import 'package:cryptosight/app/features/portfolio/data/repositories/portfolio_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PortfolioStateStatus { loading, success, error }

class PortfolioState {
  final PortfolioStateStatus status;
  final PortfolioModel? portfolio;
  final String? errorMessage;

  PortfolioState({required this.status, this.portfolio, this.errorMessage});

  factory PortfolioState.loading() => PortfolioState(
      status: PortfolioStateStatus.loading,
      portfolio: null,
      errorMessage: null);

  factory PortfolioState.success(PortfolioModel portfolio) => PortfolioState(
      status: PortfolioStateStatus.success,
      portfolio: portfolio,
      errorMessage: null);

  factory PortfolioState.error(String message) => PortfolioState(
      status: PortfolioStateStatus.error,
      portfolio: null,
      errorMessage: message);
}

class PortfolioNotifier extends StateNotifier<PortfolioState> {
  final PortfolioRepository repository;

  PortfolioNotifier({required this.repository})
      : super(PortfolioState.loading()) {
    getPortfolio();
  }

  Future<void> getPortfolio() async {
    try {
      final portfolio = await repository.getPortfolios();
      if (portfolio.isEmpty) {
        state = PortfolioState.error('No portfolio found.');
      } else {
        state = PortfolioState.success(portfolio.first);
      }
    } catch (e) {
      log('Error occurred while fetching portfolio', error: e);
      state = PortfolioState.error(e.toString());
    }
  }

  Future<void> createPortfolio(String name) async {
    log('Creating portfolio');
    try {
      final portfolio = PortfolioModel(
        name: name,
        createdAt: DateTime.now(),
        transactions: [],
      );
      await repository.addPortfolio(portfolio);
      state = PortfolioState.success(portfolio);
    } catch (e) {
      log('Error occurred while creating portfolio', error: e);
      state = PortfolioState.error(e.toString());
    }
  }

  Future<void> deletePortfolio() async {
    log('Deleting portfolio');
    try {
      await repository.deletePortfolio(0);
      state = PortfolioState.error('No portfolio found.');
    } catch (e) {
      log('Error occurred while deleting portfolio', error: e);
      state = PortfolioState.error(e.toString());
    }
  }

  Future<void> editPortfolioName(String name) async {
    log('Editing portfolio name');
    try {
      final portfolio = state.portfolio!.copyWith(name: name);
      await repository.updatePortfolio(0, portfolio);
      state = PortfolioState.success(portfolio);
    } catch (e) {
      log('Error occurred while editing portfolio name', error: e);
      state = PortfolioState.error(e.toString());
    }
  }

  Future<void> clearPortfolio() async {
    log('Clearing portfolio');
    try {
      final portfolio = state.portfolio!.copyWith(transactions: []);
      await repository.updatePortfolio(0, portfolio);
      state = PortfolioState.success(portfolio);
    } catch (e) {
      log('Error occurred while clearing portfolio', error: e);
      state = PortfolioState.error(e.toString());
    }
  }

}
