import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class CoinMarketDataItemListTile extends StatelessWidget {
  const CoinMarketDataItemListTile({super.key, required this.coin});

  final CoinMarketDataModel coin;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: ScreenConfig.symmetricDynamicPadding(0.04, 0.005),
      title: Row(
        children: [
          Text(
            coin.symbol.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenConfig.scaledFontSize(1),
            ),
          ),
          const Spacer(),
          Icon(
            coin.priceChange24h > 0
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down,
            color: coin.priceChange24h > 0 ? Colors.green : Colors.red,
            size: ScreenConfig.scaledWidth(0.06),
          ),
          Text(
            '${coin.priceChangePercentage24h} %',
            style: TextStyle(
              color: coin.priceChange24h > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: ScreenConfig.scaledFontSize(0.8),
            ),
          ),
          SizedBox(width: ScreenConfig.scaledWidth(0.03)),
          Text(
            '\$ ${coin.currentPrice.formatCoinPrice()}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenConfig.scaledFontSize(1),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coin.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: ScreenConfig.scaledFontSize(0.8),
            ),
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.01)),
          Row(
            children: [
              Text(
                'Market Cap: \$ ${coin.marketCap.toCurrencyString()}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenConfig.scaledFontSize(0.8),
                ),
              ),
              const Spacer(),
              Text(
                'Vol. (24h): \$ ${coin.totalVolume.toCurrencyString()}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenConfig.scaledFontSize(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
      leading: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(coin.image),
            backgroundColor: Colors.transparent,
            radius: ScreenConfig.scaledWidth(0.03),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
