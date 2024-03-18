import 'dart:developer';

import 'package:cryptosight/app/core/constants/app_colors.dart';
import 'package:cryptosight/app/core/router/app_router.dart';
import 'package:cryptosight/app/core/router/route_names.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/app/features/portfolio/data/models/asset_model.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/coin_data_notifier.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/portfolio_notifier.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/total_balance_and_chart_section.dart';
import 'package:cryptosight/app/features/portfolio/providers/coin_data_provider.dart';
import 'package:cryptosight/app/features/portfolio/providers/portfolio_provider.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/portfolio_name_popup.dart';
import 'package:cryptosight/shared/widgets/portfolio_settings_bottom_sheet.dart';
import 'package:cryptosight/shared/widgets/select_coin_bottom_sheet.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioState = ref.watch(portfolioNotifierProvider);

    final coinDataState = ref.watch(coinDataNotifierProvider);

    if (portfolioState.status == PortfolioStateStatus.success &&
        portfolioState.portfolio != null &&
        coinDataState.status == CoinDataStateStatus.initial) {
      Future.microtask(
        () => ref.read(coinDataNotifierProvider.notifier).fetchCoinData(),
      );
    }

    if (coinDataState.status == CoinDataStateStatus.success &&
        portfolioState.status == PortfolioStateStatus.success &&
        portfolioState.portfolio!.transactions.isNotEmpty &&
        portfolioState.portfolio!.assets.isEmpty) {
      portfolioState.portfolio!.calculateAssets(coinDataState.coinData!);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Portfolio'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ScreenConfig.scaledFontSize(1.8),
        ),
      ),
      body: portfolioState.status == PortfolioStateStatus.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : portfolioState.status == PortfolioStateStatus.error
              ? NoPortfolioWidget(onCreate: (name) {
                  ref
                      .read(portfolioNotifierProvider.notifier)
                      .createPortfolio(name);
                })
              : Padding(
                  padding: ScreenConfig.horizontalDynamicPadding(0.04),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NameAndSettings(
                          portfolioState: portfolioState,
                          ref: ref,
                        ),
                        TotalBalanceAndChartSection(
                            portfolioState: portfolioState),
                        SizedBox(height: ScreenConfig.scaledHeight(0.02)),
                        AssetsList(
                          portfolioState: portfolioState,
                          coinDataState: coinDataState,
                        ),
                        SizedBox(height: ScreenConfig.scaledHeight(0.02)),
                        AddCoinButton(
                          coinList: coinDataState.coinData ?? [],
                          calculateUserCoinAmount: (coin) {
                            return portfolioState.portfolio!
                                .getCoinAmount(coin.id);
                          },
                          onAddCoin: () async {
                            await ref
                                .read(portfolioNotifierProvider.notifier)
                                .getPortfolio();
                            ref
                                .read(portfolioNotifierProvider.notifier)
                                .calculateAssets(coinDataState.coinData!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class NameAndSettings extends StatelessWidget {
  const NameAndSettings({
    super.key,
    required this.portfolioState,
    required this.ref,
  });

  final PortfolioState portfolioState;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          portfolioState.portfolio!.name,
          style: TextStyle(
            fontSize: ScreenConfig.scaledFontSize(1.2),
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          iconSize: ScreenConfig.scaledHeight(0.03),
          onPressed: () {
            showPortfolioSettings(
              context,
              portfolioName: portfolioState.portfolio!.name,
              onEditName: (String name) {
                ref
                    .read(portfolioNotifierProvider.notifier)
                    .editPortfolioName(name);
              },
              onClearCoins: () {
                ref.read(portfolioNotifierProvider.notifier).clearPortfolio();
              },
              onDeletePortfolio: () {
                ref.read(portfolioNotifierProvider.notifier).deletePortfolio();
              },
            );
          },
        ),
      ],
    );
  }
}

class AddCoinButton extends StatelessWidget {
  const AddCoinButton({
    super.key,
    required this.coinList,
    required this.calculateUserCoinAmount,
    required this.onAddCoin,
  });
  final List<CoinSimpleDataModel> coinList;
  final double Function(CoinSimpleDataModel) calculateUserCoinAmount;
  final VoidCallback onAddCoin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showSelectCoinBottomSheet(context, coinList: coinList,
            onCoinSelected: (coin) {
          log('Coin selected: ${coin.name}');
          coin.amount = calculateUserCoinAmount(coin);
          AppRouter.navigateToAndExpectResult(RouteNames.addTransaction,
              (result) {
            log('Transaction added: $result');
            if (result == true) {
              onAddCoin();
            }
          }, arguments: coin);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade700,
      ),
      icon: Icon(
        Icons.add,
        size: ScreenConfig.scaledHeight(0.025),
        color: Colors.black,
      ),
      label: Text(
        'Add Coin to Portfolio',
        style: TextStyle(
          fontSize: ScreenConfig.scaledFontSize(0.9),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

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
                  '\$ ${asset.currentTotalValue.toStringAsFixed(2)}',
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
                      '\$ ${asset.coin.currentPrice.toStringAsFixed(2)}',
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
                      '\$ ${asset.profit.toStringAsFixed(2)}',
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

class NoPortfolioWidget extends StatelessWidget {
  const NoPortfolioWidget({super.key, required this.onCreate});

  final Function(String) onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You have no portfolio yet.',
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(1.4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text('Add a portfolio to get started.',
              style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.9),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showPortfolioNamePopup(
                context: context,
                title: 'Create Portfolio',
                buttonText: 'Create',
                onAction: onCreate,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
            ),
            child: Text(
              'Add Portfolio',
              style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.9),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
