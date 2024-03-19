import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class BalanceAndProfit extends StatelessWidget {
  const BalanceAndProfit({
    super.key,
    required this.totalInvestment,
    required this.totalProfit,
    required this.totalProfitPercentage,
  });

  final double totalInvestment;
  final double totalProfit;
  final double totalProfitPercentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total balance:',
              style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.9),
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              '\$ ${totalInvestment.toCurrency()}',
              style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(1.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        Visibility(
          visible: totalProfit != 0,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    totalProfit > 0
                        ? Icons.arrow_drop_up
                        : totalProfit < 0
                            ? Icons.arrow_drop_down
                            : Icons.remove,
                    size: ScreenConfig.scaledHeight(0.02),
                    color: totalProfit > 0
                        ? Colors.green
                        : totalProfit < 0
                            ? Colors.red
                            : Colors.grey.shade400,
                  ),
                  Text(
                    '${totalProfitPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: ScreenConfig.scaledFontSize(0.9),
                      color: totalProfit > 0
                          ? Colors.green
                          : totalProfit < 0
                              ? Colors.red
                              : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              Text(
                '\$ ${totalProfit.toCurrency()}',
                style: TextStyle(
                  fontSize: ScreenConfig.scaledFontSize(0.9),
                  fontWeight: FontWeight.w600,
                  color: totalProfit > 0
                      ? Colors.green
                      : totalProfit < 0
                          ? Colors.red
                          : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
