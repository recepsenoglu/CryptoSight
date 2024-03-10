import 'package:cryptosight/services/news_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/news_filter_model.dart'; 
import '../data/repositories/news_repository.dart'; 
import '../domain/notifiers/news_notifier.dart';

// Provider for ApiService
final apiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService();
});

// Provider for NewsRepository that depends on ApiService
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return NewsRepository(apiService: apiService);
});

// Provider for managing NewsFilterModel state
final newsFilterProvider = StateProvider<NewsFilterModel>((ref) {
  return NewsFilterModel();
});

// Provider for NewsNotifier that depends on NewsRepository
final newsNotifierProvider =
    StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return NewsNotifier(ref, repository: repository);
});
