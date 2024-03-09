enum NewsFilterKind {
  all,
  rising,
  hot,
  bullish,
  bearish,
  important,
  lol
}

class NewsFilterModel {
  final String? filter;
  final String? currencies;
  final String? regions;
  final String kind;

  NewsFilterModel({
    this.filter,
    this.currencies,
    this.regions,
    this.kind = 'news',
  });
}