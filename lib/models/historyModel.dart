// To parse this JSON data, do
//
//     final getAllTranslation = getAllTranslationFromJson(jsonString);

import 'dart:convert';

HistoryModelForLocal getAllTranslationFromJson(String str) => HistoryModelForLocal.fromJson(json.decode(str));

String getAllTranslationToJson(HistoryModelForLocal data) => json.encode(data.toJson());

class HistoryModelForLocal {
    final String userId;
    final String selectedLanguage;
    final String searchedWord;
    final String translation1;
    final String translation2;
    final DateTime createdAt;

    HistoryModelForLocal({
        required this.userId,
        required this.selectedLanguage,
        required this.searchedWord,
        required this.translation1,
        required this.translation2,
        required this.createdAt
    });

    factory HistoryModelForLocal.fromJson(Map<String, dynamic> json) => HistoryModelForLocal(
        userId: json["userId"],
        selectedLanguage: json["selectedLanguage"],
        searchedWord: json["searchedWord"],
        translation1: json["translation1"],
        translation2: json["translation2"],
        createdAt: DateTime.parse(json["created_at"])

    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "selectedLanguage": selectedLanguage,
        "searchedWord": searchedWord,
        "translation1": translation1,
        "translation2": translation2,
    };
}
