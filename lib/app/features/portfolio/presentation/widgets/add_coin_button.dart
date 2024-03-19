import 'dart:developer';

import 'package:cryptosight/app/core/router/app_router.dart';
import 'package:cryptosight/app/core/router/route_names.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/select_coin_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AddCoinButton extends StatelessWidget {
  const AddCoinButton({
    super.key,
    required this.coinList,
    required this.calculateUserCoinAmount,
    required this.onAddCoin,
  });
  final List<CoinSimpleDataModel> coinList;
  final double Function(CoinSimpleDataModel) calculateUserCoinAmount;
  final VoidCallback onAddCoin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        if (coinList.isEmpty) {
          return;
        }
        showSelectCoinBottomSheet(context, coinList: coinList,
            onCoinSelected: (coin) {
          log('Coin selected: ${coin.name}');
          coin.amount = calculateUserCoinAmount(coin);
          AppRouter.navigateToAndExpectResult(RouteNames.addTransaction,
              (result) {
            log('Transaction added: $result');
            if (result == true) {
              onAddCoin();
            }
          }, arguments: coin);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade700,
      ),
      icon: Icon(
        Icons.add,
        size: ScreenConfig.scaledHeight(0.025),
        color: Colors.black,
      ),
      label: Text(
        'Add Coin to Portfolio',
        style: TextStyle(
          fontSize: ScreenConfig.scaledFontSize(0.9),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
