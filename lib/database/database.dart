import 'package:multitranslation/models/getAllTranslation.dart';
import 'package:multitranslation/models/historyModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class MultilangualDatabase {
  //create database instance
  static Database? _db;
  //initializing Database
  Future<Database?> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDatabase();
    return _db;
  }

  initializeDatabase() async {
    try {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "multiLangualDatabase");
      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
    } catch (e) {
      print(e);
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE translations(id INTEGER PRIMARY KEY AUTOINCREMENT,english TEXT NOT NULL, soomaali TEXT NOT NULL,arabic TEXT NOT NULL,created_at TEXT NOT NULL,updated_at TEXT NOT NULL)");
    await db.execute("""CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        selectedLanguage TEXT NOT NULL,
        searchedWord TEXT NOT NULL,
        translation1 TEXT NOT NULL,
        translation2 TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL
    )""");
    // await db.execute(
    //     "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, todoName TEXT NOT NULL, dateTime TEXT,taskStatus TEXT)");
  }

  Future<bool> insertDataToDictionary(
      GetAllTranslation getAllTranslation) async {
    try {
      var dbClient = await database;
      dbClient!.insert("translations", getAllTranslation.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteWordFromDictionary(int id) async {
    try {
      var dbClient = await database;
      dbClient!.delete("translations", where: "id=?", whereArgs: [id]);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<GetAllTranslation>> getAllTranslations() async {
    var dbclient = await database;
    final List<Map<String, dynamic>> queryResult =
        await dbclient!.query("translations");
    return queryResult.map((e) => GetAllTranslation.fromJson(e)).toList();
  }

  // Future<bool> updateNote(NotesModel notesModel) async {
  //   try {
  //     var dbclient = await database;
  //     await dbclient!.update(
  //       "notes",
  //       notesModel.toMap(),
  //       where: "id=?",
  //       whereArgs: [notesModel.id],
  //     );
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
  Future<List<String>> fetchSuggestions(String selectedLang) async {
    var dbclient = await database;
    final List<Map<String, dynamic>> searchResult = await dbclient!.query(
      "translations",
      columns: [selectedLang], // Select only the specified column
    );

    // Extract the values of the selected column from the query result
    List<String> columnData = [];
    for (var row in searchResult) {
      columnData.add(row[selectedLang]);
    }

    return columnData;
  }

  Future<List<String>> searchSingleWord(
      String selectedLang, String searchWord) async {
    var dbclient = await database;

    // Construct the WHERE clause to search for the searched word using wildcard characters
    String whereClause = "$selectedLang LIKE ?";
    String whereArg =
        '%$searchWord%'; // Using % wildcard for substring matching

    final List<Map<String, dynamic>> searchResult = await dbclient!.query(
      "translations",
      columns: [selectedLang], // Select only the specified column
      where: whereClause,
      whereArgs: [whereArg],
    );

    // Extract the values of the selected column from the filtered query result
    List<String> columnData = [];
    for (var row in searchResult) {
      columnData.add(row[selectedLang]);
    }

    return columnData;
  }

  Future<List<GetAllTranslation>> searchWords(
      String lang, List<String> searchWords) async {
    var dbclient = await database;

    // Construct the WHERE clause dynamically
    String whereClause = searchWords.map((_) => "$lang = ?").join(" OR ");
    List<dynamic> whereArgs =
        searchWords.toList(); // No need to modify the search words

    final List<Map<String, dynamic>> searchResult = await dbclient!.query(
      "translations",
      where: whereClause,
      whereArgs: whereArgs,
    );

    if (searchResult.isEmpty) {
      return []; // Return an empty list if no results are found
    }

    return searchResult.map((e) => GetAllTranslation.fromJson(e)).toList();
  }

//insert history into Table
  Future<bool> insertHistory(HistoryModelForLocal historyModel) async {
    try {
      var dbClient = await database;
      dbClient!.insert("history", historyModel.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<HistoryModelForLocal>> getLocalHistory(int userId) async {
    try {
      var dbClient = await database;

      // Perform the query to retrieve records for the specified user
      List<Map<String, dynamic>> results = await dbClient!.query(
        'history',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      // Convert the query results to a list of HistoryModelForLocal objects
      List<HistoryModelForLocal> historyList = results.map((row) {
        return HistoryModelForLocal.fromJson(row);
      }).toList();

      return historyList;
    } catch (e) {
      print(e);
      return []; // Return an empty list if an error occurs
    }
  }

  Future<void> clearTable() async {
    try {
      var dbClient = await database;

      // Delete all rows from the table
      await dbClient!.delete('translations');
    } catch (e) {
      throw Exception();
    }
  }

  // todos insertion deletion and updation
  // Future<bool> insertToDo(TodoModel todoModel) async {
  //   try {
  //     var dbClient = await database;
  //     dbClient!.insert("todos", todoModel.toMap());
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  // Future<bool> deleteToDo(int id) async {
  //   try {
  //     var dbClient = await database;
  //     dbClient!.delete("todos", where: "id=?", whereArgs: [id]);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  // Future<List<TodoModel>> getAllToDos() async {
  //   var dbclient = await database;
  //   final List<Map<String, dynamic>> queryResult =
  //       await dbclient!.query("todos");
  //   return queryResult.map((e) => TodoModel.fromMap(e)).toList();
  // }

  // Future<bool> updateToDos(TodoModel todos) async {
  //   try {
  //     var dbclient = await database;
  //     await dbclient!.rawUpdate("UPDATE todos SET taskStatus=? WHERE id=?",
  //         [todos.taskStatus, todos.id]);
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
