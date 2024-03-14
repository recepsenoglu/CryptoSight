import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

void showPortfolioNamePopup({
  required BuildContext context,
  required String title,
  required String buttonText,
  String? initialName,
  required Function(String) onAction,
}) {
  final TextEditingController portfolioNameController =
      TextEditingController(text: initialName);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ScreenConfig.scaledFontSize(1),
        ),
        contentPadding: ScreenConfig.symmetricDynamicPadding(0.04, 0.02),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: portfolioNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Portfolio Name",
                labelStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.grey[900],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.8),
                  ), // Adjust the focused border color
                ),
                contentPadding:
                    ScreenConfig.symmetricDynamicPadding(0.02, 0.02),
              ),
            ),
          ],
        ),
        actionsPadding: ScreenConfig.horizontalDynamicPadding(0.02)
            .copyWith(bottom: ScreenConfig.scaledHeight(0.01)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: ScreenConfig.scaledFontSize(0.9),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (portfolioNameController.text.isNotEmpty) {
                onAction(portfolioNameController.text);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.amber.shade700, 
              padding: ScreenConfig.symmetricDynamicPadding(0.08, 0.005),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenConfig.scaledFontSize(0.9),
              ),
            ),
          ),
        ],
      );
    },
  );
}
