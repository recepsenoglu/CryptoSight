import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/app/features/market_cap/domain/notifiers/market_cap_notifier.dart';
import 'package:cryptosight/app/features/market_cap/presentation/widgets/coin_market_data_item_list_tile.dart';
import 'package:cryptosight/app/features/market_cap/providers/market_cap_provider.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketCapScreen extends ConsumerWidget {
  const MarketCapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketCapState = ref.watch(marketCapNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Market Cap'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ScreenConfig.scaledFontSize(1.8),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (marketCapState.status == MarketCapStateStatus.loading)
            const Center(child: CircularProgressIndicator()),
          if (marketCapState.status == MarketCapStateStatus.error)
            Text(marketCapState.errorMessage!),
          if (marketCapState.status == MarketCapStateStatus.success)
            Expanded(
              child: ListView.builder(
                itemCount: marketCapState.marketCap!.length,
                itemBuilder: (context, index) {
                  final CoinMarketDataModel coin =
                      marketCapState.marketCap![index];

                  return CoinMarketDataItemListTile(coin: coin);
                },
              ),
            ),
        ],
      ),
    );
  }
}
