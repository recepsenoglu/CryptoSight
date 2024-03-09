import 'package:cryptosight/app/features/news/data/models/news_filter_model.dart';
import 'package:cryptosight/app/features/news/data/models/news_model.dart';
import 'package:cryptosight/services/news_api_service.dart';

class NewsRepository {
  final NewsApiService apiService;

  NewsRepository({required this.apiService});

  Future<List<NewsModel>> getNews(NewsFilterModel filter) async {
    final rawData = await apiService.fetchNews(
      filter: filter.filter,
      currencies: filter.currencies,
      regions: filter.regions,
      kind: filter.kind,
    );
    final List<dynamic> results = rawData['results'];
    return results.map<NewsModel>((json) => NewsModel.fromJson(json)).toList();
  }
}
