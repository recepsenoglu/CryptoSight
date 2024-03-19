import 'package:cryptosight/app/features/portfolio/domain/notifiers/coin_data_notifier.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/portfolio_notifier.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/add_coin_button.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/assets_list.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/balance_and_profit.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/chart_item_list.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/assets_pie_chart.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/name_and_settings.dart';
import 'package:cryptosight/app/features/portfolio/presentation/widgets/no_portfolio_widget.dart';
import 'package:cryptosight/app/features/portfolio/providers/coin_data_provider.dart';
import 'package:cryptosight/app/features/portfolio/providers/portfolio_provider.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/portfolio_settings_bottom_sheet.dart';
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
                          portfolioName: portfolioState.portfolio!.name,
                          onMoreTapped: () {
                            showPortfolioSettings(
                              context,
                              portfolioName: portfolioState.portfolio!.name,
                              onEditName: (p0) {
                                ref
                                    .read(portfolioNotifierProvider.notifier)
                                    .editPortfolioName(p0);
                              },
                              onClearCoins: () {
                                ref
                                    .read(portfolioNotifierProvider.notifier)
                                    .clearPortfolio();
                              },
                              onDeletePortfolio: () {
                                ref
                                    .read(portfolioNotifierProvider.notifier)
                                    .deletePortfolio();
                              },
                            );
                          },
                        ),
                        Container(
                          padding:
                              ScreenConfig.symmetricDynamicPadding(0.04, 0.01),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              BalanceAndProfit(
                                totalInvestment:
                                    portfolioState.portfolio!.totalInvestment,
                                totalProfit:
                                    portfolioState.portfolio!.totalProfit,
                                totalProfitPercentage: portfolioState
                                    .portfolio!.totalProfitPercentage,
                              ),
                              AssetsPieChart(
                                assets: portfolioState.portfolio!.assets,
                                totalInvestment:
                                    portfolioState.portfolio!.totalInvestment,
                              ),
                              ChartItemList(
                                assets: portfolioState.portfolio!.assets,
                                totalInvestment:
                                    portfolioState.portfolio!.totalInvestment,
                              ),
                            ],
                          ),
                        ),
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
