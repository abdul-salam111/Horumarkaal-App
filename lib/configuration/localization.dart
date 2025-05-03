import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static Locale get locale => Get.deviceLocale!;

  static const fallbackLocale = Locale('en', 'US');

  static final languages = ['English', 'Somali', 'Arabic'];

  static void changeLocale(Locale locale) {
    Get.updateLocale(locale);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'Settings': 'Settings',
          'Language': 'Language',
          'Discussion': 'Discussion',
          'Favorite Categries': 'Favorite Categries',
          'Profile': 'Profile'
          // Add more English translations here
        },
        'so': {
          'Congratulation!': 'Hambalyo!',
          'You Score': 'dhibooc',
          'Exam Completed Succesfully': 'Imtixaanki guul baad ku dhameysay',
          'You Attempted questions': 'Waxaad isku dayday',
          'and': "su' aalood",
          'are answered correct.': 'na si sax ah ayaad uga jawaabtay',
          'Back': 'Noqo',
          'Next': 'Xiga',
          'Exercise & Quizzes': 'Leeyli & Imtixaan',
          'Learning Plan': 'Qorshaha Barashada',
          'Language': 'Luuqad',
          'Submit': 'Gudbi',
          'Next Page': 'Bogga Xiga',
          'Log Out': 'Ka Bax',
          'Search':'Raadi',
          'Quiz by Words':'Imtihan Qoraal ah',
          "All Quizez":"Dhammaan Imtixaanka",
          "Question":"Su'aal"
        },
        'ar': {
          'Congratulation!': 'مبروك!',
          'You Score': 'نقطة احرزت',
          'Exam Completed Succesfully': 'تم الانتهاء من الامتحان بنجاح',
          'You Attempted questions': ' لقد حاولت سؤالا وتمت الإجابة على',
          'are answered correct.': 'منها بشكل صحيح',
          'Back': 'أرجع',
          'Next': 'التالي',
          'Exercise & Quizzes': 'تمارين وامتحان',
          'Learning Plan': 'خطة التعليم',
          'Language': 'لغة',
          'Submit': 'تقديم',
          'Next Page': 'الصفحة التالية',
          'Log Out': 'تسجيل الخروج',
          'Search':'بحث',
          'Quiz by Words':'اختبار حسب الكلمات',
          "All Quizez":"جميع الاختبارات",
          'Question':'سؤال'
        }
      };
}
