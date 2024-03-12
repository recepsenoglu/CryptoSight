import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class CoinDetailHeader extends StatelessWidget {
  const CoinDetailHeader({
    super.key,
    required this.coinImage,
    required this.coinSymbol,
    required this.coinName,
    required this.coinPrice,
    required this.coinPriceChangePercentage24h,
  });

  final String coinImage;
  final String coinSymbol;
  final String coinName;
  final double coinPrice;
  final double coinPriceChangePercentage24h;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          coinImage,
          width: ScreenConfig.scaledWidth(0.1),
          height: ScreenConfig.scaledWidth(0.1),
        ),
        SizedBox(width: ScreenConfig.scaledWidth(0.03)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coinSymbol.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenConfig.scaledFontSize(1),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${coinPrice.formatCoinPrice()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenConfig.scaledFontSize(1),
                    ),
                  ),
                  SizedBox(width: ScreenConfig.scaledWidth(0.025)),
                  Container(
                    padding: ScreenConfig.verticalDynamicPadding(0.004),
                    decoration: BoxDecoration(
                      color: coinPriceChangePercentage24h > 0
                          ? Colors.green.shade600
                          : Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          coinPriceChangePercentage24h > 0
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: ScreenConfig.scaledWidth(0.04),
                          color: Colors.white,
                        ),
                        Text(
                          '${coinPriceChangePercentage24h.toStringAsFixed(2)}% ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenConfig.scaledFontSize(0.75),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                coinName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenConfig.scaledFontSize(0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
