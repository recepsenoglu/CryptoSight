import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

void showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmButtonText,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: ScreenConfig.scaledFontSize(1),
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: ScreenConfig.scaledFontSize(0.9),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: ScreenConfig.scaledFontSize(0.9),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              confirmButtonText,
              style: TextStyle(
                color: Colors.red,
                fontSize: ScreenConfig.scaledFontSize(0.9),
              ),
            ),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
