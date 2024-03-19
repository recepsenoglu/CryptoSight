import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class NameAndSettings extends StatelessWidget {
  const NameAndSettings({
    super.key,
    required this.portfolioName,
    required this.onMoreTapped,
  });

  final String portfolioName;
  final VoidCallback onMoreTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          portfolioName,
          style: TextStyle(
            fontSize: ScreenConfig.scaledFontSize(1.2),
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          iconSize: ScreenConfig.scaledHeight(0.03),
          onPressed: onMoreTapped,
        ),
      ],
    );
  }
}
