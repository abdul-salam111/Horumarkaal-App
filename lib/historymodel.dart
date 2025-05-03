// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
    final bool? success;
    final String? message;
    final Data? data;

    HistoryModel({
        this.success,
        this.message,
        this.data,
    });

    factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? currentPage;
    final List<Datum>? data;
    final String? firstPageUrl;
    final int? from;
    final int? lastPage;
    final String? lastPageUrl;
    final List<Link>? links;
    final dynamic nextPageUrl;
    final String? path;
    final int? perPage;
    final dynamic prevPageUrl;
    final int? to;
    final int? total;

    Data({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
    };
}

class Datum {
    final DateTime? date;
    final List<Record>? record;

    Datum({
        this.date,
        this.record,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        record: json["record"] == null ? [] : List<Record>.from(json["record"]!.map((x) => Record.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "record": record == null ? [] : List<dynamic>.from(record!.map((x) => x.toJson())),
    };
}

class Record {
    final String? id;
    final SelectedLang? selectedLang;
    final String? word;
    final String? trans1;
    final String? trans2;
    final String? userId;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Record({
        this.id,
        this.selectedLang,
        this.word,
        this.trans1,
        this.trans2,
        this.userId,
        this.createdAt,
        this.updatedAt,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        selectedLang: selectedLangValues.map[json["selected_lang"]]!,
        word: json["word"],
        trans1: json["trans_1"],
        trans2: json["trans_2"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "selected_lang": selectedLangValues.reverse[selectedLang],
        "word": word,
        "trans_1": trans1,
        "trans_2": trans2,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

enum SelectedLang {
    ARABIC,
    ENGLISH,
    SOOMAALI
}

final selectedLangValues = EnumValues({
    "arabic": SelectedLang.ARABIC,
    "english": SelectedLang.ENGLISH,
    "soomaali": SelectedLang.SOOMAALI
});

class Link {
    final String? url;
    final String? label;
    final bool? active;

    Link({
        this.url,
        this.label,
        this.active,
    });

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
