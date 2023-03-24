import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationPreference {
  static const LANGUAGE_CODE = "LANGCODE";

  Future<Locale> setLocale(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LANGUAGE_CODE, value);
    return _locale(value);
  }

  Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return _locale(prefs.getString(LANGUAGE_CODE)!);
  }

  Locale _locale(String languageCode) {
    Locale temp;
    if (languageCode == 'hr') {
      temp = const Locale('hr', '');
    } else {
      temp = const Locale('en', '');
    }
    return temp;
  }
}
