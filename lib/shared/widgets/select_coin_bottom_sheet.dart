import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

void showSelectCoinBottomSheet(BuildContext context,
    {required List<CoinSimpleDataModel> coinList,
    required Function(CoinSimpleDataModel) onCoinSelected}) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    enableDrag: false,
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Coin',
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(1.2),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final coin = coinList[index];
                  return ListTile(
                    title: Text(coin.name),
                    subtitle: Text(coin.symbol.toUpperCase()),
                    titleTextStyle: TextStyle(
                      fontSize: ScreenConfig.scaledFontSize(1),
                      fontWeight: FontWeight.w600,
                    ),
                    subtitleTextStyle: TextStyle(
                      fontSize: ScreenConfig.scaledFontSize(0.9),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(coin.image),
                      radius: ScreenConfig.scaledWidth(0.05),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: ScreenConfig.scaledWidth(0.05),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onCoinSelected(coin);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
