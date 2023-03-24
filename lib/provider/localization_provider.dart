import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irrigation/localization_preference.dart';

class LocalizationProvider extends ChangeNotifier {
  LocalizationPreference localizationPreference = LocalizationPreference();

  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  initLocale() async {
    _locale = await localizationPreference.getLocale();
  }

  setLocale(String value) async {
    _locale = await localizationPreference.setLocale(value);
    Get.updateLocale(_locale);
    notifyListeners();
  }
}
