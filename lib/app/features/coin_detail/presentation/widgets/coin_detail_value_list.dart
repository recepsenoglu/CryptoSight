import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class CoinDetailValueList extends StatelessWidget {
  const CoinDetailValueList({
    super.key,
    required this.coin,
  });

  final CoinMarketDataModel coin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyValueRow(
          valueKey: 'Vol. (24h)',
          value: '\$${coin.totalVolume.toCurrency()}',
        ),
        KeyValueRow(
          valueKey: 'Market Cap',
          value: '\$${coin.marketCap.toCurrency()}',
        ),
        KeyValueRow(
          valueKey: 'Circulating Supply',
          value: coin.circulatingSupply.toCurrency(),
        ),
        KeyValueRow(
          valueKey: 'Total Supply',
          value: coin.totalSupply?.toCurrency(),
        ),
        KeyValueRow(
          valueKey: 'Max Supply',
          value: coin.maxSupply?.toCurrency(),
        ),
        KeyValueRow(
          valueKey: 'ATH',
          value: '\$${coin.ath.toCurrency()}',
        ),
        KeyValueRow(
          valueKey: 'ATH Change',
          value: '${coin.athChangePercentage.toCurrencyString()}%',
        ),
        KeyValueRow(
          valueKey: 'ATL',
          value: '\$${coin.atl.toCurrency()}',
        ),
        KeyValueRow(
          valueKey: 'ATL Change',
          value: '${coin.atlChangePercentage.toCurrencyString()}%',
        ),
      ],
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.valueKey,
    required this.value,
  });

  final String valueKey;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenConfig.scaledHeight(0.008)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$valueKey:',
            style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.85),
                color: Colors.white),
          ),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
