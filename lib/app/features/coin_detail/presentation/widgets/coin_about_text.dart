import 'package:cryptosight/app/features/coin_detail/domain/notifiers/coin_detail_notifier.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class CoinAboutText extends StatelessWidget {
  const CoinAboutText({
    super.key,
    required this.coinName,
    required this.coinDetailState,
  });

  final String coinName;
  final CoinDetailState coinDetailState;

  @override
  Widget build(BuildContext context) {
    if (coinDetailState.status == CoinDetailStateStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (coinDetailState.status == CoinDetailStateStatus.success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About $coinName',
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(1.1),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.01)),
          Text(
            coinDetailState.coinDetail!.description,
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(0.85),
            ),
          ),
        ],
      );
    }

    return Container();
  }
}
