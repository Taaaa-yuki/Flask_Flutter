import 'package:flutter/material.dart';

class AppColors {
  static const Color yellow = Color.fromARGB(255, 255, 208, 0);
  static const Color orange = Color.fromARGB(255, 245, 127, 23);
  static const Color grey = Color.fromARGB(255, 224, 224, 224);
  static const Color black = Color.fromARGB(255, 0, 0, 0);

  static const MaterialColor primaryColor = MaterialColor(
    _appPrimaryColorValue,
    <int, Color>{
      50: Color.fromRGBO(255, 254, 228, 1),
      100: Color.fromRGBO(255, 249, 196, 1),
      200: Color.fromRGBO(255, 244, 163, 1),
      300: Color.fromRGBO(255, 238, 130, 1),
      400: Color.fromRGBO(255, 233, 107, 1),
      500: Color.fromRGBO(255, 228, 84, 1),
      600: Color.fromRGBO(255, 223, 61, 1),
      700: Color.fromRGBO(255, 218, 38, 1),
      800: Color.fromRGBO(255, 213, 15, 1),
      900: Color.fromRGBO(255, 208, 0, 1),
    },
  );
  static const int _appPrimaryColorValue = 0xFFFFD000;
}
