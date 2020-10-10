import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'training.dart';

const int _primaryColorValue = 0xFFC56C35;
const Color primaryColor = Color(_primaryColorValue);
const Color secondaryColor = Color(0xFF890E23);
const Color textOnWhiteColor = Color(0xFF3D1220);

const MaterialColor primaryColorSwatch = MaterialColor(_primaryColorValue, <int, Color>{
  50: Color(0xFFF8EDE7),
  100: Color(0xFFEED3C2),
  200: Color(0xFFE2B69A),
  300: Color(0xFFD69872),
  400: Color(0xFFCE8253),
  500: Color(_primaryColorValue),
  600: Color(0xFFBF6430),
  700: Color(0xFFB85928),
  800: Color(0xFFB04F22),
  900: Color(0xFFA33D16),
});

Future<String> get statsFilePath async =>
    (await getApplicationDocumentsDirectory()).path + "/stats.json";

// Though SharedPreferences.setValue() returns Future<bool>,
// The value changes synchronously.
extension SharedPreferencesExtension on SharedPreferences {

  String get sessionDifficulty =>
      getString("difficulty") ?? MathConstants.sessionDefaultDifficulty;
  set sessionDifficulty(String val) => setString("difficulty",val);

  //in minutes
  int get sessionDuration =>
      getInt("duration") ?? MathConstants.defaultDuration;
  set sessionDuration(int val) => setInt("duration",val);
}