import 'package:cryptosight/app/features/news/data/models/news_filter_model.dart';
import 'package:cryptosight/app/features/news/providers/news_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/news_repository.dart';

enum NewsStateStatus { loading, success, error }

class NewsState {
  final NewsStateStatus status;
  final List<NewsModel>? news;
  final String? errorMessage;
  final NewsFilterModel? currentFilter;

  NewsState(
      {required this.status, this.news, this.errorMessage, this.currentFilter});

  factory NewsState.loading() => NewsState(
      status: NewsStateStatus.loading, news: null, errorMessage: null);

  factory NewsState.success(List<NewsModel> news, {NewsFilterModel? filter}) =>
      NewsState(
          status: NewsStateStatus.success,
          news: news,
          errorMessage: null,
          currentFilter: filter);

  factory NewsState.error(String message, {NewsFilterModel? filter}) =>
      NewsState(
          status: NewsStateStatus.error,
          news: null,
          errorMessage: message,
          currentFilter: filter);
}

class NewsNotifier extends StateNotifier<NewsState> {
  final NewsRepository repository;
  final Ref ref;

  NewsNotifier(this.ref, {required this.repository})
      : super(NewsState.loading()) {
    // Initialize with fetching news
    fetchNewsWithFilters();
  }

  Future<void> fetchNewsWithFilters() async {
    state = NewsState.loading();
    try {
      final filter = ref.read(newsFilterProvider);
      final news = await repository.getNews(filter);
      state = NewsState.success(news);
    } catch (e) {
      state = NewsState.error(e.toString());
    }
  }

  void refreshNews() {
    fetchNewsWithFilters();
  }

  void updateFilter({
    String? newFilter,
    String? newCurrencies,
    String? newRegions,
    String newKind = 'news',
  }) {
    final currentState = ref.read(newsFilterProvider);
    final updatedFilter = NewsFilterModel(
      filter: newFilter ?? currentState.filter,
      currencies: newCurrencies ?? currentState.currencies,
      regions: newRegions ?? currentState.regions,
      kind: newKind,
    );

    if (currentState == updatedFilter) return;

    ref.read(newsFilterProvider.notifier).state = updatedFilter;

    fetchNewsWithFilters();
  }
}
