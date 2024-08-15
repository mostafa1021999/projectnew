import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF003473),
  secondaryHeaderColor: const Color(0xFFCC003F),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  appBarTheme:  const AppBarTheme(
    surfaceTintColor: Colors.white,
    elevation: 10,
    shadowColor: Color(0xFFC2CAD9),
  ),
  colorScheme: ColorScheme(
    background: const Color(0xFFF3F3F3),
    brightness: Brightness.light,
    primary: const Color(0xFFEEBD8D),
    onPrimary: const Color(0xFF003473),
    secondary: const Color(0xFFCC003F),
    onSecondary: const Color(0xFFCC003F),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    onBackground: const Color(0xFFC3CAD9),
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
    // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),

  ),
);