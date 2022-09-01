import 'package:flutter/material.dart';

class Styles {
static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          //0A1931  // white yellow 0xFFFCF8EC
          const Color(0xFF00001a),
      primaryColor: Colors.black,
      backgroundColor: const Color(0xFFF3E4C2),
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: const Color(0xFF1a1f3c),
          ),
      cardColor:
          isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
      canvasColor: Colors.black,
      // buttonTheme: Theme.of(context)
      //     .buttonTheme
      //     .copyWith(colorScheme: const ColorScheme.light()),
    );
  }
}
