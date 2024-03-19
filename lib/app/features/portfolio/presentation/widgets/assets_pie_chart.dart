import 'package:cryptosight/app/core/constants/app_colors.dart';
import 'package:cryptosight/app/features/portfolio/data/models/asset_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssetsPieChart extends StatefulWidget {
  const AssetsPieChart({
    super.key,
    required this.assets,
    required this.totalInvestment,
  });

  final List<AssetModel> assets;
  final double totalInvestment;

  @override
  State<AssetsPieChart> createState() => _AssetsPieChartState();
}

class _AssetsPieChartState extends State<AssetsPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.assets.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: ScreenConfig.symmetricDynamicPadding(0.04, 0.01),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: ScreenConfig.verticalDynamicPadding(0.01),
        child: Stack(
          children: [
            SizedBox(
              height: ScreenConfig.scaledHeight(0.3),
              child: PieChart(
                PieChartData(
                  sections: widget.assets
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
                  centerSpaceRadius: ScreenConfig.scaledHeight(0.09),
                ),
              ),
            ),
            touchedIndex != -1
                ? Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.assets[touchedIndex].coin.symbol
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: ScreenConfig.scaledFontSize(1.2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$ ${widget.assets[touchedIndex].currentTotalValue.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: ScreenConfig.scaledFontSize(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.assets[touchedIndex].totalAmount} coins',
                            style: TextStyle(
                              fontSize: ScreenConfig.scaledFontSize(0.9),
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            '${(widget.assets[touchedIndex].currentTotalValue / widget.totalInvestment * 100).toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: ScreenConfig.scaledFontSize(0.9),
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
