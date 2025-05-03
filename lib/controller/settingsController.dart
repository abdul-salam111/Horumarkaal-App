import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multitranslation/configuration/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSelectedLanguage();
  }

  void fetchSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedLanguage = prefs.getString('language');
    if (storedLanguage != null) {
      selectedLanguage.value = storedLanguage;
      // Update the locale based on the stored language
      LocalizationService.changeLocale(Locale(storedLanguage == 'English'
          ? 'en'
          : storedLanguage == 'Somali'
              ? 'so'
              : storedLanguage == 'Arabic'
                  ? 'ar'
                  : 'none'));
    }
  }

  void changeLanguage(String language) async {
    selectedLanguage.value = language;
    LocalizationService.changeLocale(Locale(language == 'English'
        ? 'en'
        : language == 'Somali'
            ? 'so'
            : language == 'Arabic'
                ? 'ar'
                : 'none'));

    // Save the selected language to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}
