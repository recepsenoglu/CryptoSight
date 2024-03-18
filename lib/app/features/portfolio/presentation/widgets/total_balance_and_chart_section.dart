import 'dart:developer';

import 'package:cryptosight/app/core/constants/app_colors.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/portfolio_notifier.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalBalanceAndChartSection extends StatefulWidget {
  const TotalBalanceAndChartSection({
    super.key,
    required this.portfolioState,
  });

  final PortfolioState portfolioState;

  @override
  State<TotalBalanceAndChartSection> createState() =>
      _TotalBalanceAndChartSectionState();
}

class _TotalBalanceAndChartSectionState
    extends State<TotalBalanceAndChartSection> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ScreenConfig.symmetricDynamicPadding(0.04, 0.01),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
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
                    '\$ ${widget.portfolioState.portfolio!.totalInvestment.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: ScreenConfig.scaledFontSize(1.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.portfolioState.portfolio!.totalProfit > 0
                            ? Icons.arrow_drop_up
                            : widget.portfolioState.portfolio!.totalProfit < 0
                                ? Icons.arrow_drop_down
                                : Icons.remove,
                        size: ScreenConfig.scaledHeight(0.02),
                        color: widget.portfolioState.portfolio!.totalProfit > 0
                            ? Colors.green
                            : widget.portfolioState.portfolio!.totalProfit < 0
                                ? Colors.red
                                : Colors.grey.shade400,
                      ),
                      Text(
                        '${widget.portfolioState.portfolio!.totalProfitPercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: ScreenConfig.scaledFontSize(0.9),
                          color: widget.portfolioState.portfolio!.totalProfit >
                                  0
                              ? Colors.green
                              : widget.portfolioState.portfolio!.totalProfit < 0
                                  ? Colors.red
                                  : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$ ${widget.portfolioState.portfolio!.totalProfit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: ScreenConfig.scaledFontSize(0.9),
                      fontWeight: FontWeight.w600,
                      color: widget.portfolioState.portfolio!.totalProfit > 0
                          ? Colors.green
                          : widget.portfolioState.portfolio!.totalProfit < 0
                              ? Colors.red
                              : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.01)),
          SizedBox(
            height: ScreenConfig.scaledHeight(0.3),
            child: PieChart(
              PieChartData(
                sections: widget.portfolioState.portfolio!.assets
                    .map(
                      (asset) => PieChartSectionData(
                        showTitle: false,
                        value: asset.currentTotalValue,
                        radius: asset.index == touchedIndex
                            ? ScreenConfig.scaledHeight(0.07)
                            : ScreenConfig.scaledHeight(0.055),
                        color: assetColors[asset.index % assetColors.length],
                      ),
                    )
                    .toList(),
                sectionsSpace: 0,
                pieTouchData: PieTouchData(
                  touchCallback: (flTouchEvent, pieTouchResponse) {
                    if (pieTouchResponse?.touchedSection != null) {
                      final touchedSection = pieTouchResponse!.touchedSection;
                      setState(() {
                        touchedIndex = touchedSection!.touchedSectionIndex;
                      });
                    }
                  },
                ),
                centerSpaceRadius: ScreenConfig.scaledHeight(0.1),
              ),
            ),
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.01)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.portfolioState.portfolio!.assets.length,
            itemBuilder: (context, index) {
              final asset = widget.portfolioState.portfolio!.assets[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: ScreenConfig.scaledHeight(0.01),
                ),
                child: Row(
                  children: [
                    Container(
                      width: ScreenConfig.scaledHeight(0.015),
                      height: ScreenConfig.scaledHeight(0.015),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: assetColors[asset.index % assetColors.length],
                      ),
                    ),
                    SizedBox(width: ScreenConfig.scaledWidth(0.02)),
                    Text(
                      asset.coin.name,
                      style: TextStyle(
                        fontSize: ScreenConfig.scaledFontSize(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' (${(asset.currentTotalValue / widget.portfolioState.portfolio!.totalInvestment * 100).toStringAsFixed(2)}%)',
                      style: TextStyle(
                        fontSize: ScreenConfig.scaledFontSize(0.8),
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
