import 'package:cryptosight/app/features/news/data/models/news_model.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/utils/webview_helpers.dart';
import 'package:flutter/material.dart';

class NewsItemListTile extends StatelessWidget with WebViewHelpers {
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
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: ScreenConfig.scaledFontSize(1),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.link, size: ScreenConfig.scaledFontSize(0.9)),
                  SizedBox(width: ScreenConfig.scaledWidth(0.01)),
                  Text(
                    domain,
                    style:
                        TextStyle(fontSize: ScreenConfig.scaledFontSize(0.7)),
                  ),
                  SizedBox(width: ScreenConfig.scaledWidth(0.01)),
                ],
              ),
              if (currencies.isNotEmpty)
                Flexible(
                  child: Wrap(
                    spacing: ScreenConfig.scaledWidth(0.015),
                    children: currencies
                        .take(15)
                        .map(
                          (currency) => Text(
                            currency.code,
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: ScreenConfig.scaledFontSize(
                                    0.75)), // Text style inside chip
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
          SizedBox(height: ScreenConfig.scaledHeight(0.007)),
          Text(
            date.toLocal().when(),
            style: TextStyle(fontSize: ScreenConfig.scaledFontSize(0.8)),
          ),
        ],
      ),
      onTap: () {
        openWebView(context, url, title: title);
      },
    );
  }
}
