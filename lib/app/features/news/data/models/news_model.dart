class NewsModel {
  final String kind;
  final String domain;
  final Source source;
  final String title;
  final String publishedAt;
  final String slug;
  final List<Currency> currencies;
  final int id;
  final String url;
  final String createdAt;

  NewsModel({
    required this.kind,
    required this.domain,
    required this.source,
    required this.title,
    required this.publishedAt,
    required this.slug,
    required this.currencies,
    required this.id,
    required this.url,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      kind: json['kind'] ?? 'unknown',
      domain: json['domain'] ?? 'unknown',
      source: Source.fromJson(json['source'] as Map<String, dynamic>? ?? {}),
      title: json['title'] ?? 'No title available',
      publishedAt: json['published_at'] ?? '',
      slug: json['slug'] ?? '',
      currencies: (json['currencies'] as List<dynamic>?)
              ?.map<Currency>(
                  (item) => Currency.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class Source {
  final String title;
  final String region;
  final String domain;
  final dynamic path;

  Source({
    required this.title,
    required this.region,
    required this.domain,
    this.path,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      title: json['title'] ?? 'unknown',
      region: json['region'] ?? 'unknown',
      domain: json['domain'] ?? 'unknown',
      path: json['path'],
    );
  }
}

class Currency {
  final String code;
  final String title;
  final String slug;
  final String url;
  static final List<String> currencies = [
    'BTC',
    'ETH',
    'XRP',
    'LTC',
    'BCH',
    'ADA',
    'DOT',
    'LINK',
    'BNB',
    'XLM',
    'USDT',
    'USDC',
    'DOGE',
    'UNI',
    'WBTC',
    'AAVE',
    'ATOM',
    'EOS',
    'FIL',
    'TRX',
    'XTZ',
    'YFI',
    'ZEC',
    'ZRX'
  ];

  Currency({
    required this.code,
    required this.title,
    required this.slug,
    required this.url,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] ?? 'unknown',
      title: json['title'] ?? 'unknown',
      slug: json['slug'] ?? 'unknown',
      url: json['url'] ?? 'unknown',
    );
  }
}

class Votes {
  final int negative;
  final int positive;
  final int important;
  final int liked;
  final int disliked;
  final int lol;
  final int toxic;
  final int saved;
  final int comments;

  Votes({
    required this.negative,
    required this.positive,
    required this.important,
    required this.liked,
    required this.disliked,
    required this.lol,
    required this.toxic,
    required this.saved,
    required this.comments,
  });

  factory Votes.fromJson(Map<String, dynamic> json) {
    return Votes(
      negative: json['negative'],
      positive: json['positive'],
      important: json['important'],
      liked: json['liked'],
      disliked: json['disliked'],
      lol: json['lol'],
      toxic: json['toxic'],
      saved: json['saved'],
      comments: json['comments'],
    );
  }
}

class Metadata {
  final String description;

  Metadata({
    required this.description,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      description: json['description'],
    );
  }
}
