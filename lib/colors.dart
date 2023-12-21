import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFEBF2E9),
  100: Color(0xFFCEE0C9),
  200: Color(0xFFAECBA5),
  300: Color(0xFF8DB680),
  400: Color(0xFF74A665),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF548E43),
  700: Color(0xFF4A833A),
  800: Color(0xFF417932),
  900: Color(0xFF306822),
});
const int _primaryPrimaryValue = 0xFF5C964A;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFB8FFA9),
  200: Color(_primaryAccentValue),
  400: Color(0xFF65FF43),
  700: Color(0xFF50FF2A),
});
const int _primaryAccentValue = 0xFF8FFF76;
