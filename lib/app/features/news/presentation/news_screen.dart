import 'package:cryptosight/app/features/news/domain/notifiers/news_notifier.dart';
import 'package:cryptosight/app/features/news/presentation/widgets/currency_selection_chips.dart';
import 'package:cryptosight/app/features/news/presentation/widgets/filter_chips.dart';
import 'package:cryptosight/app/features/news/presentation/widgets/news_item_list_tile.dart';
import 'package:cryptosight/app/features/news/presentation/widgets/region_select_button.dart';
import 'package:cryptosight/app/features/news/providers/news_provider.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the state of news to rebuild the widget accordingly
    final newsState = ref.watch(newsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ScreenConfig.scaledFontSize(1.8),
        ),
        actions: [
          RegionSelectButton(
            onRegionSelected: (region) {
              ref
                  .read(newsNotifierProvider.notifier)
                  .updateFilter(newRegions: region);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterChips(
            onFilterChanged: (filter) {
              ref
                  .read(newsNotifierProvider.notifier)
                  .updateFilter(newFilter: filter);
            },
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.01)),
          CurrencySelectionChips(
            onSelectionChanged: (selectedCurrencies) {
              ref
                  .read(newsNotifierProvider.notifier)
                  .updateFilter(newCurrencies: selectedCurrencies.join(','));
            },
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.01)),
          const Divider(),
          newsState.status == NewsStateStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : newsState.status == NewsStateStatus.error
                  ? Text('Error: ${newsState.errorMessage}')
                  : Expanded(
                      child: ListView.separated(
                        itemCount: newsState.news?.length ?? 0,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final newsItem = newsState.news![index];
                          return NewsItemListTile(
                            title: newsItem.title,
                            date: newsItem.publishedAt.toDateTime(),
                            domain: newsItem.source.domain,
                            url:
                                "https://cryptopanic.com/news/click/${newsItem.id}/",
                            currencies: newsItem.currencies,
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
