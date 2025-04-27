import 'package:flutter/material.dart';

class SizeConfig{
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late bool isTabletDevice;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    isTabletDevice = _mediaQueryData.size.shortestSide >= 600;
  }

  static double fontSize(double size) {
  double scale = isTabletDevice
      ? 1.2
      : screenWidth / 375;

  double result = size * scale;

  double minFontSize = size * 0.85;
  double maxFontSize = isTabletDevice ? size * 1.4 : size * 1.15;

  return result.clamp(minFontSize, maxFontSize);
}

}