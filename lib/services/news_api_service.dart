import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsApiService {
  final Dio _dio = Dio();

  final String _apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
  final String _baseUrl = 'https://cryptopanic.com/api/v1/';

  NewsApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  Future<dynamic> fetchNews({
    String? filter,
    String? currencies,
    String? regions,
    String kind = 'news',
  }) async {
    const String endpoint = 'posts/';

    final Map<String, dynamic> queryParameters = {
      'auth_token': _apiKey,
      'kind': kind,
    };

    if (filter != null) {
      queryParameters['filter'] = filter;
    }
    if (currencies != null) {
      queryParameters['currencies'] = currencies;
    }
    if (regions != null) {
      queryParameters['regions'] = regions;
    }

    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data; // Access the response data
    } on Error catch (e) {
      log('Failed to load news: ${e.toString()}', error: e);
      throw Exception('Failed to load news: ${e.toString()}');
    }
  }
}
