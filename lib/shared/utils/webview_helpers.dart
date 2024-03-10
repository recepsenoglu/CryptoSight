import 'package:cryptosight/app/core/router/app_router.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

mixin WebViewHelpers {
  void openWebView(BuildContext context, String url,
      {String title = 'Web Page'}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WebViewScreen(url: url, title: title),
    ));
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  int progress = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            if (change.url != null) {
              if (change.url != widget.url &&
                  change.url!.startsWith('https://cryptopanic.com')) {
                AppRouter.goBack();
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ScreenConfig.scaledFontSize(1),
          ),
        ),
      ),
      body: progress < 100
          ? Center(
              child: CircularProgressIndicator(
                value: progress.toDouble(),
                backgroundColor: Colors.grey,
              ),
            )
          : WebViewWidget(controller: controller),
    );
  }
}
