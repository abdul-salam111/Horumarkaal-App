// To parse this JSON data, do
//
//     final getAllTranslation = getAllTranslationFromJson(jsonString);




class GetAllTranslation {

    final String? english;
    final String? soomaali;
    final String? arabic;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    GetAllTranslation({

        required this.english,
        required this.soomaali,
        required this.arabic,
        required this.createdAt,
        required this.updatedAt,
    });

    factory GetAllTranslation.fromJson(Map<String, dynamic> json) => GetAllTranslation(

        english: json["english"],
        soomaali: json["soomaali"],
        arabic: json["arabic"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {

        "english": english,
        "soomaali": soomaali,
        "arabic": arabic,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
