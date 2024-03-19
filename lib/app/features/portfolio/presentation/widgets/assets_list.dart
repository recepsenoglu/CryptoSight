
import 'dart:developer';

import 'package:cryptosight/app/features/portfolio/domain/notifiers/coin_data_notifier.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/portfolio_notifier.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class AssetsList extends StatelessWidget {
  const AssetsList({
    super.key,
    required this.portfolioState,
    required this.coinDataState,
  });

  final PortfolioState portfolioState;
  final CoinDataState coinDataState;

  @override
  Widget build(BuildContext context) {
    if (portfolioState.portfolio!.transactions.isEmpty) {
      return Center(
        child: Text(
          'No assets in portfolio.',
          style: TextStyle(
            fontSize: ScreenConfig.scaledFontSize(1),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (coinDataState.status == CoinDataStateStatus.loading ||
        coinDataState.status == CoinDataStateStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (coinDataState.status == CoinDataStateStatus.error) {
      return Center(
        child: Text(
          'Error loading assets.',
          style: TextStyle(
            fontSize: ScreenConfig.scaledFontSize(1),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: portfolioState.portfolio!.assets.length,
      itemBuilder: (context, index) {
        final asset = portfolioState.portfolio!.assets[index];

        return Card(
          margin: EdgeInsets.only(bottom: ScreenConfig.scaledHeight(0.02)),
          child: ListTile(
            leading: Column(
              children: [
                CircleAvatar(
                    radius: ScreenConfig.scaledHeight(0.02),
                    backgroundImage: NetworkImage(asset.coin.image),
                    backgroundColor: Colors.transparent,
                    onBackgroundImageError: (exception, stackTrace) {
                      log('Error loading image: $exception');
                    }),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  asset.coin.name,
                  style: TextStyle(
                    fontSize: ScreenConfig.scaledFontSize(1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$ ${asset.currentTotalValue.toCurrency()}',
                  style: TextStyle(
                    fontSize: ScreenConfig.scaledFontSize(1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                SizedBox(height: ScreenConfig.scaledHeight(0.005)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ ${asset.coin.currentPrice.toCurrency()}',
                      style: TextStyle(
                        fontSize: ScreenConfig.scaledFontSize(0.9),
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      '${asset.totalAmount} coins',
                      style: TextStyle(
                        fontSize: ScreenConfig.scaledFontSize(0.9),
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenConfig.scaledHeight(0.005)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          asset.profit > 0
                              ? Icons.arrow_drop_up
                              : asset.profit < 0
                                  ? Icons.arrow_drop_down
                                  : Icons.remove,
                          size: ScreenConfig.scaledHeight(0.02),
                          color: asset.profit > 0
                              ? Colors.green
                              : asset.profit < 0
                                  ? Colors.red
                                  : Colors.grey.shade400,
                        ),
                        Text(
                          '${asset.profitPercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: ScreenConfig.scaledFontSize(0.9),
                            color: asset.profit > 0
                                ? Colors.green
                                : asset.profit < 0
                                    ? Colors.red
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$ ${asset.profit.toCurrency()}',
                      style: TextStyle(
                        fontSize: ScreenConfig.scaledFontSize(0.9),
                        color: asset.profit > 0
                            ? Colors.green
                            : asset.profit < 0
                                ? Colors.red
                                : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
