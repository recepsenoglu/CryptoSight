import 'package:dio/dio.dart';

class MarketApiService {
  final Dio _dio = Dio();

  final String _baseUrl = 'https://api.coingecko.com/api/v3/';

  MarketApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  Future<dynamic> fetchMarketCap() async {
    const String endpoint = 'coins/markets';

    final Map<String, dynamic> queryParameters = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': 10,
      'page': 1,
      'sparkline': false,
      'price_change_percentage': '1h,24h,7d',
    };

    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data; // Access the response data
    } on Error catch (e) {
      throw Exception('Failed to load market cap: ${e.toString()}');
    }
  }

  Future<dynamic> fetchCoinData(String coinId) async {
    final String endpoint = 'coins/$coinId';
    try {
      final response = await _dio.get(endpoint);
      return response.data; // Access the response data
    } on Error catch (e) {
      throw Exception('Failed to load coin data for $coinId: ${e.toString()}');
    }
  }
}