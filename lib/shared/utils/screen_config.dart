import 'package:flutter/material.dart';

class ScreenConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _aspectRatio;
  static const double _baseFontSize = 16;
  static late TextScaler _textScaler;

  static void init(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    _screenWidth = mediaQueryData.size.width;
    _screenHeight = mediaQueryData.size.height;
    _aspectRatio = _screenWidth / _screenHeight;
    _textScaler = mediaQueryData.textScaler;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get aspectRatio => _aspectRatio;

  static double scaledWidth(double percent) => _screenWidth * percent;
  static double scaledHeight(double percent) => _screenHeight * percent;

  static EdgeInsets dynamicPadding(double percent) =>
      EdgeInsets.all(_screenWidth * percent);
  static EdgeInsets horizontalDynamicPadding(double percent) =>
      EdgeInsets.symmetric(horizontal: _screenWidth * percent);
  static EdgeInsets verticalDynamicPadding(double percent) =>
      EdgeInsets.symmetric(vertical: _screenHeight * percent);
  static EdgeInsets symmetricDynamicPadding(
          double horizontal, double vertical) =>
      EdgeInsets.symmetric(
          horizontal: _screenWidth * horizontal,
          vertical: _screenHeight * vertical);

  static BorderRadius dynamicBorderRadius(double radius) {
    final double value = _screenWidth < 500 ? radius : radius * 2;
    return BorderRadius.circular(value);
  }

  static double scaledFontSize(double scale) {
    return _textScaler.scale(_baseFontSize * scale);
  }

  static double scaledFontSizeAdvanced(double scaleFactor) {
    double baseScale = _screenWidth / 375;
    double scaledFontSize = _baseFontSize * baseScale * scaleFactor;
    return _textScaler.scale(scaledFontSize);
  }
}
