import 'package:flutter/material.dart';

class Constants {
  static const smallScreen = 640;

  static const String aud = 'https://walletconnect.org/login';
  static const String domain = 'walletconnect.org';
}

class StyleConstants {
  static const Color backgroundColor = Color(0xFF111B25);
  static const Color backgroundColorLighter = Color.fromARGB(255, 31, 48, 63);
  static const Color backgroundColorLightest = Color.fromARGB(255, 41, 64, 84);
  static const Color backgroundColorDarkGray = Color.fromARGB(255, 30, 30, 30);
  static const Color primaryColor = Color(0xFF2980B9);

  static const Color darkGray = Color(0xFF141414);
  static const Color lightGray = Color.fromARGB(255, 196, 196, 196);

  static const Color successColor = Color(0xFF2BEE6C);
  static const Color errorColor = Color(0xFFF25A67);

  // Linear
  static const double linear8 = 8;
  static const double linear16 = 16;
  static const double linear24 = 24;
  static const double linear32 = 32;
  static const double linear48 = 48;
  static const double linear56 = 56;
  static const double linear72 = 72;
  static const double linear80 = 80;

  // Magic Number
  static const double magic10 = 10;
  static const double magic14 = 14;
  static const double magic20 = 20;
  static const double magic40 = 40;
  static const double magic64 = 64;

  // Width
  static const double maxWidth = 400;

  static const double inputHeight = linear80 + linear16;

  // Borders
  static final inputBorder = BoxDecoration(
    border: Border.all(
      color: backgroundColorLighter,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(4),
  );

  // Text styles
  static const TextStyle titleText = TextStyle(
    color: Colors.white,
    fontSize: magic40,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle subtitleText = TextStyle(
    color: Colors.white,
    fontSize: linear24,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: linear16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle bodyTextBold = TextStyle(
    color: Colors.white,
    fontSize: magic14,
    fontWeight: FontWeight.w900,
  );
  static const TextStyle bodyText = TextStyle(
    color: Colors.white,
    fontSize: magic14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyLightGray = TextStyle(
    color: lightGray,
    fontSize: magic14,
  );

  // Bubbles
  static const EdgeInsets bubblePadding = EdgeInsets.symmetric(
    vertical: linear8,
    horizontal: linear8,
  );
}
