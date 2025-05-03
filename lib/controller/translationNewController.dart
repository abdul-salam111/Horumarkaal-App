import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multitranslation/database/database.dart';
import 'package:multitranslation/models/getAllTranslation.dart';
import 'package:multitranslation/models/historyModel.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';
import 'package:path_provider/path_provider.dart';

class TranslationNewController extends GetxController {
  final searchController = TextEditingController().obs;
  MultilangualDatabase? multilangualDatabase;
  FlutterTts flutterTts = FlutterTts();
  var isSearch = false.obs;
  var searchSingleWord = "".obs;
  @override
  onInit() {
    super.onInit();
    multilangualDatabase = MultilangualDatabase();
    multilangualDatabase!.initializeDatabase();
  }

  RxList<String> suggestionsList = <String>[].obs;
  RxList<String> dataList = <String>[].obs;
  List<GetAllTranslation> wordsList = [];

  Future<List<GetAllTranslation>> getTranslation(
      List<String> words, String lang) async {
    try {
      wordsList = await multilangualDatabase!.searchWords(lang, words);
      for (int i = 0; i < words.length; i++) {
        await insertHistory(HistoryModelForLocal(
          selectedLanguage: lang,
          translation1: lang == "english"
              ? wordsList[i].arabic!
              : lang == "soomaali"
                  ? wordsList[i].arabic!
                  : wordsList[i].soomaali!,
          userId: StorageServices.to.getString(userId),
          translation2: lang == "english"
              ? wordsList[i].soomaali!
              : lang == "soomaali"
                  ? wordsList[i].english
                  !
                  : wordsList[i].english!,
          searchedWord: words[i],
          createdAt: DateTime.now(),
        ));
      }
      return wordsList;
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      throw Exception();
    }
  }

  Future<List<String>> fetchSuggestions(String lang) async {
    try {
      suggestionsList.value =
          await multilangualDatabase!.fetchSuggestions(lang);
      return suggestionsList;
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception();
    }
  }

  Future<List<String>> searchOneWord(String lang, String word) async {
    try {
      suggestionsList.value =
          await multilangualDatabase!.searchSingleWord(lang, word);

      return suggestionsList;
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception();
    }
  }

  Future<void> insertHistory(HistoryModelForLocal historymodelforlocal) async {
    try {
      await multilangualDatabase!.insertHistory(historymodelforlocal);
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception();
    }
  }

  Future<List<HistoryModelForLocal>> getLocalHistory(userId) async {
    try {
      List<HistoryModelForLocal> data =
          await multilangualDatabase!.getLocalHistory(userId);

      return data;
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception();
    }
  }

  Future<void> speak(String text, String selectedLanguage) async {
    await flutterTts.setLanguage(
        selectedLanguage); // Replace with the language code you want to use (e.g., "so-SO" for Somali, "ar-SA" for Arabic)
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<void> textToSpeech({required String textToSpeak}) async {
    // final String apiKey = Platform.environment['SnAEBdbq564owoayOZpBX1YvRVZTlzaO5Qkbluo6'] ?? '';
    const String voice = 'Cabdi';
    //const String text = 'Hello, ruhan sir how are you?';
    const String url =
        'https://api.narakeet.com/text-to-speech/mp3?voice=$voice';

    final http.Client client = http.Client();

    try {
      final http.Response response = await client.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/octet-stream',
          'Content-Type': 'text/plain',
          'x-api-key': "M4DDnkYVI47m6oXani06b8djrBPrjfoM9rIwguqe",
        },
        body: utf8.encode(textToSpeak),
      );

      if (response.statusCode == 200) {
        final Directory tempDir = await getTemporaryDirectory();
        final File file = File('${tempDir.path}/output.mp3');
        final IOSink sink = file.openWrite();
        sink.add(response.bodyBytes);
        await sink.close();

        // Play the audio
        await playAudio(file.path);

        print('File saved at: ${file.path}');
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }
  }

  Future<void> playAudio(String filePath) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(
      UrlSource(filePath),
    );
  }

  Future clearTablesData()async{
    await multilangualDatabase!.clearTable();
  }
}
