import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/domain/notifiers/market_chart_notifier.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/widgets/coin_about_text.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/widgets/coin_detail_header.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/widgets/coin_detail_value_list.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/widgets/market_data_line_chart_section.dart';
import 'package:cryptosight/app/features/coin_detail/providers/coin_detail_provider.dart';
import 'package:cryptosight/app/features/coin_detail/providers/market_chart_provider.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinDetailScreen extends ConsumerWidget {
  const CoinDetailScreen(this.coin, {super.key});

  final CoinMarketDataModel coin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDetailState = ref.watch(coinDetailNotifierProvider(coin.id));
    final marketChartState = ref.watch(marketChartNotifierProvider(coin.id));

    if (marketChartState.status == MarketChartStateStatus.error ||
        marketChartState.status == MarketChartStateStatus.errorLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(marketChartState.errorMessage ?? 'An error occurred')),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0),
      body: Padding(
        padding: ScreenConfig.symmetricDynamicPadding(0.04, 0.005),
        child: Column(
          children: [
            CoinDetailHeader(
              coinImage: coin.image,
              coinSymbol: coin.symbol,
              coinName: coin.name,
              coinPrice: coin.currentPrice,
              coinPriceChangePercentage24h: coin.priceChangePercentage24h,
            ),
            SizedBox(height: ScreenConfig.scaledHeight(0.01)),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  MarketDataLineChartSection(
                    marketChartState: marketChartState,
                    onMarketDataTypeSelectionUpdated:
                        (MarketChartDataType marketChartDataType) {
                      ref
                          .read(marketChartNotifierProvider(coin.id).notifier)
                          .setMarketChartDataType(marketChartDataType);
                    },
                    onTimeIntervalSelectionUpdated:
                        (MarketChartTimeInterval marketChartTimeInterval) {
                      ref
                          .read(marketChartNotifierProvider(coin.id).notifier)
                          .onMarketChartTimeIntervalChanged(
                              marketChartTimeInterval);
                    },
                    onRetry: () {
                      ref
                          .read(marketChartNotifierProvider(coin.id).notifier)
                          .reTryFetch();
                    },
                  ),
                  SizedBox(height: ScreenConfig.scaledHeight(0.04)),
                  CoinDetailValueList(coin: coin),
                  SizedBox(height: ScreenConfig.scaledHeight(0.03)),
                  CoinAboutText(
                      coinName: coin.name, coinDetailState: coinDetailState),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
