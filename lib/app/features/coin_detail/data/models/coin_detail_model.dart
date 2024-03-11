class CoinDetailModel {
  final String id;
  final String symbol;
  final String name;
  final String? webSlug;
  final String? assetPlatformId;
  final Map<String, String?> platforms;
  final Map<String, DetailPlatform> detailPlatforms;
  final int blockTimeInMinutes;
  final String? hashingAlgorithm;
  final List<String> categories;
  final bool previewListing;
  final String? publicNotice;
  final List<dynamic>? additionalNotices;
  final Map<String, String?> localization;
  final String description;

  CoinDetailModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.webSlug,
    required this.assetPlatformId,
    required this.platforms,
    required this.detailPlatforms,
    required this.blockTimeInMinutes,
    required this.hashingAlgorithm,
    required this.categories,
    required this.previewListing,
    this.publicNotice,
    required this.additionalNotices,
    required this.localization,
    required this.description,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) =>
      CoinDetailModel(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        webSlug: json['web_slug'],
        assetPlatformId: json['asset_platform_id'],
        platforms: Map.from(json['platforms']),
        detailPlatforms: Map.from(json['detail_platforms'])
            .map((k, v) => MapEntry(k, DetailPlatform.fromJson(v))),
        blockTimeInMinutes: json['block_time_in_minutes'],
        hashingAlgorithm: json['hashing_algorithm'],
        categories: List<String>.from(json['categories']),
        previewListing: json['preview_listing'],
        publicNotice: json['public_notice'],
        additionalNotices: List<dynamic>.from(json['additional_notices']),
        localization:
            Map.from(json['localization']).map((k, v) => MapEntry(k, v)),
        description: removeHtmlTags(json['description']['en'] ?? ''),
      );

  static String removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

class DetailPlatform {
  final int? decimalPlace;
  final String? contractAddress;

  DetailPlatform({
    this.decimalPlace,
    required this.contractAddress,
  });

  factory DetailPlatform.fromJson(Map<String, dynamic> json) => DetailPlatform(
        decimalPlace: json['decimal_place'],
        contractAddress: json['contract_address'],
      );
}
