import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multitranslation/database/database.dart';
import 'package:multitranslation/models/getAllTranslation.dart';
import 'package:path_provider/path_provider.dart';

class TranslationControllre extends GetxController {


  TextEditingController searchController = TextEditingController();

  RxList<String> dataList = <String>[].obs;
  List<GetAllTranslation> translations = [];
  FlutterTts flutterTts = FlutterTts();
    MultilangualDatabase? multilangualDatabase;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    flutterTts.setLanguage("en-US");
    multilangualDatabase = MultilangualDatabase();
    multilangualDatabase!.initializeDatabase();
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
          'x-api-key': "SnAEBdbq564owoayOZpBX1YvRVZTlzaO5Qkbluo6",
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



  Map<String, dynamic>? translationsData;
  RxList<String> words = <String>[].obs;
  RxList<String> nullList = <String>[].obs;
 

  // Future<void> fetchExactTranslation(
  //     String query, String selectedLanguage, String token) async {
  //   try {
    

  //   dataList=await multilangualDatabase!.searchSingleWord(selectedLanguage, query)
  //   } catch (e) {
  //     // Handle exceptions
  //     print('Exception during API call: $e');
  //   }
  // }

  //fetch data to store in mysql
  Future<void> fetchDataToStoreInMySql(
      String query, String selectedLanguage, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://admin.horumarkaal.app/api/app/get-all-translate'),
        headers: {
          'Authorization':
              "Bearer $token", // Replace with your actual auth token
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        // final Map<String, dynamic> data = json.decode(response.body);
        // List<dynamic> dataListFromApi = data['data'];

        // dataList.value = dataListFromApi.cast<String>();
      } else {
        // Handle error
        print('API call failed');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during API call: $e');
    }
  }

  // Future<void> fetch(String query, String token) async {
  //   print(token);
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://horumarkaal.app/api/app/search-translate'),
  //       headers: {
  //         'Authorization':
  //             "Bearer $token", // Replace with your actual auth token
  //       },
  //       body: {
  //         'lang': query,
  //         // 'query': query,
  //       },
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       List<dynamic> dataListFromApi = data['data'];

  //       dataList.value = dataListFromApi.cast<String>();
  //     } else {
  //       // Handle error
  //       print('API call failed');
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     print('Exception during API call: $e');
  //   }
  // }
}
