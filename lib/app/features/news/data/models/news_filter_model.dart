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