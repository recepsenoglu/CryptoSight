import 'package:cryptosight/app/features/news/data/models/news_model.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/webview_helpers.dart';
import 'package:flutter/material.dart';

class NewsItemListTile extends StatelessWidget with WebViewHelpers{
  const NewsItemListTile({
    super.key,
    required this.title,
    required this.date,
    required this.domain,
    required this.url,
    required this.currencies,
  });

  final String title;
  final DateTime date;
  final String domain;
  final String url;
  final List<Currency> currencies;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.link, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    domain,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              if (currencies.isNotEmpty)
                Flexible(
                  child: Wrap(
                    spacing: 8, // Add space between each chip
                    children: currencies.take(15)
                        .map(
                          (currency) => Text(
                            currency.code,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.amber,
                            ), // Text style inside chip
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            date.toLocal().when(),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      onTap: () {
        openWebView(context, url, title: title);
      },
    );
  }
}
