import 'package:cryptosight/app/features/news/data/models/news_filter_model.dart';
import 'package:cryptosight/app/features/news/domain/notifiers/news_notifier.dart';
import 'package:cryptosight/app/features/news/providers/news_provider.dart';
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
            onPressed: () => ref.read(newsNotifierProvider.notifier).refreshNews(),
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
                    return ListTile(
                      title: Text(newsItem.title),
                      subtitle: Text(newsItem.slug),
                      // Add more details or an onTap handler as needed
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateFilters(ref);
        },
        child: const Icon(Icons.filter_list),
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
