import 'package:cryptosight/app/features/portfolio/domain/notifiers/portfolio_notifier.dart';
import 'package:cryptosight/app/features/portfolio/providers/portfolio_provider.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/portfolio_name_popup.dart';
import 'package:cryptosight/shared/widgets/portfolio_settings_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioState = ref.watch(portfolioNotifierProvider);

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
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
                                onClearCoins: () {},
                                onDeletePortfolio: () {
                                  ref
                                      .read(portfolioNotifierProvider.notifier)
                                      .deletePortfolio();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      TotalBalanceAndChartSection(
                          portfolioState: portfolioState),
                      SizedBox(height: ScreenConfig.scaledHeight(0.02)),
                      AssetsList(portfolioState: portfolioState),
                      SizedBox(height: ScreenConfig.scaledHeight(0.02)),
                      const AddCoinButton(),
                    ],
                  ),
                ),
    );
  }
}

class AddCoinButton extends StatelessWidget {
  const AddCoinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
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
  });

  final PortfolioState portfolioState;

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
    return Expanded(
      child: ListView.builder(
        itemCount: portfolioState.portfolio!.transactions.length,
        itemBuilder: (context, index) {
          final portfolio = portfolioState.portfolio!.transactions[index];
          return ListTile(
            title: Text(portfolio.name),
            subtitle: Text(portfolio.amount.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}

class TotalBalanceAndChartSection extends StatelessWidget {
  const TotalBalanceAndChartSection({
    super.key,
    required this.portfolioState,
  });

  final PortfolioState portfolioState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ScreenConfig.symmetricDynamicPadding(0.04, 0.01),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
            '\$ ${portfolioState.portfolio!.totalInvestment.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(1.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
