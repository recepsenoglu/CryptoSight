import 'dart:developer';

import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/app/features/portfolio/data/models/transaction_model.dart';
import 'package:cryptosight/app/features/portfolio/data/repositories/portfolio_repository.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AddTransactionStateStatus { stable, saving, success, error }

class AddTransactionState {
  final AddTransactionStateStatus status;
  final TransactionModel? transaction;
  final String? errorMessage;

  const AddTransactionState({
    required this.status,
    this.transaction,
    this.errorMessage,
  });

  factory AddTransactionState.stable(TransactionModel transactionModel) =>
      AddTransactionState(
          status: AddTransactionStateStatus.stable,
          transaction: transactionModel);

  factory AddTransactionState.saving(TransactionModel transactionModel) =>
      AddTransactionState(
        status: AddTransactionStateStatus.saving,
        transaction: transactionModel,
      );

  factory AddTransactionState.success(TransactionModel transactionModel) =>
      AddTransactionState(
        status: AddTransactionStateStatus.success,
        transaction: transactionModel,
      );

  factory AddTransactionState.error(
          TransactionModel transactionModel, String message) =>
      AddTransactionState(
        status: AddTransactionStateStatus.error,
        transaction: transactionModel,
        errorMessage: message,
      );
}

class AddTransactionNotifier extends StateNotifier<AddTransactionState> {
  final PortfolioRepository repository;
  final CoinSimpleDataModel coin;
  final TextEditingController dateController = TextEditingController();

  AddTransactionNotifier({required this.repository, required this.coin})
      : super(AddTransactionState.stable(TransactionModel(
          createdAt: DateTime.now(),
          transactionDate: DateTime.now(),
          coinId: coin.id,
        ))) {
    changePrice(coin.currentPrice.toString());
    dateController.text =
        state.transaction!.transactionDate.toFormattedString();
  }

  void changeTransactionType() {
    state.transaction!.type = state.transaction!.type == TransactionType.BUY
        ? TransactionType.SELL
        : TransactionType.BUY;
    state = AddTransactionState.stable(state.transaction!);
  }

  void changeAmount(String amount) {
    state.transaction!.amount = double.tryParse(amount) ?? 0;
    log('Amount: ${state.transaction!.amount}');
    state = AddTransactionState.stable(state.transaction!);
  }

  void changePrice(String price) {
    state.transaction!.price = double.tryParse(price) ?? 0;
    state = AddTransactionState.stable(state.transaction!);
  }

  void changeDate(DateTime date) {
    dateController.text = date.toFormattedString();
    state.transaction!.transactionDate = date;
    state = AddTransactionState.stable(state.transaction!);
  }

  Future<void> saveTransaction() async {
    state = AddTransactionState.saving(state.transaction!);
    if (state.transaction!.amount <= 0.0) {
      state =
          AddTransactionState.error(state.transaction!, 'Amount cannot be 0');
      return;
    }

    if (state.transaction!.price == 0) {
      state =
          AddTransactionState.error(state.transaction!, 'Price cannot be 0');
      return;
    }

    if (state.transaction!.type == TransactionType.SELL) {
      if (state.transaction!.amount > coin.amount) {
        state = AddTransactionState.error(
            state.transaction!, 'You do not have enough coins to sell!');
        return;
      }
    }
    try {
      state.transaction!.createdAt = DateTime.now();
      await repository.addTransaction(0, state.transaction!.copyWith());
      state = AddTransactionState.success(state.transaction!);
    } catch (e) {
      log('Error occurred while adding transaction', error: e);
      state = AddTransactionState.error(state.transaction!, e.toString());
    }
  }

  Future resetState() async {
    log('Resetting state');
    state.transaction!.amount = 0;
    state.transaction!.price = coin.currentPrice;
    state.transaction!.transactionDate = DateTime.now();
    changeDate(DateTime.now());
  }
}
