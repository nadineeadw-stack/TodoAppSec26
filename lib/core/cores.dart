import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 93, 47, 173);
  static const Color primaryColorOfScreen = const Color.fromARGB(
    255,
    249,
    248,
    252,
  );
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 36, 26, 168),
      Color.fromARGB(255, 85, 58, 183),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color colorOfTextUnderCon = const Color.fromARGB(
    255,
    154,
    153,
    153,
  );
}
