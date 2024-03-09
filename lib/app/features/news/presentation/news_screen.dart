import 'package:cryptosight/app/features/news/data/models/news_filter_model.dart';
import 'package:cryptosight/app/features/news/domain/notifiers/news_notifier.dart';
import 'package:cryptosight/app/features/news/presentation/widgets/news_item_list_tile.dart';
import 'package:cryptosight/app/features/news/providers/news_provider.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
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
        title: const Text('Latest News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(newsNotifierProvider.notifier).refreshNews(),
          ),
        ],
      ),
      body: newsState.status == NewsStateStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : newsState.status == NewsStateStatus.error
              ? Text('Error: ${newsState.errorMessage}')
              : ListView.builder(
                  itemCount: newsState.news?.length ?? 0,
                  itemBuilder: (context, index) {
                    final newsItem = newsState.news![index];
                    return NewsItemListTile(
                      title: newsItem.title,
                      date: newsItem.publishedAt.toDateTime(),
                      domain: newsItem.source.domain,
                      url: "https://cryptopanic.com/news/click/${newsItem.id}/",
                      currencies: newsItem.currencies,
                    );
                  },
                ),
    );
  }

  void updateFilters(WidgetRef ref) {
    ref.read(newsFilterProvider.notifier).state = NewsFilterModel(
      filter: null,
      currencies: null,
      regions: null,
      kind: 'news',
    );

    // Directly fetch news with new filters
    ref.read(newsNotifierProvider.notifier).fetchNewsWithFilters();
  }
}
