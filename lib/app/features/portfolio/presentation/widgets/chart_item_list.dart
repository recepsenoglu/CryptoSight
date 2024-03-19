import 'package:cryptosight/app/core/constants/app_colors.dart';
import 'package:cryptosight/app/features/portfolio/data/models/asset_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class ChartItemList extends StatelessWidget {
  const ChartItemList({
    super.key,
    required this.assets,
    required this.totalInvestment,
  });

  final List<AssetModel> assets;
  final double totalInvestment;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final AssetModel asset = assets[index];

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
                ' (${(asset.currentTotalValue / totalInvestment * 100).toStringAsFixed(2)}%)',
                style: TextStyle(
                  fontSize: ScreenConfig.scaledFontSize(0.8),
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
