// Import statements

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multitranslation/controller/translationController.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:http/http.dart' as http;
import '../storage/storage.dart';

class QuizController extends GetxController {
  final String apiUrl =
      "https://admin.horumarkaal.app/api/app/get-questions?word=help&type=english to soomaali";
  List<Map<String, dynamic>> quizData = [];
  String selectedAnswers = "";
  String selectedAnswerss = "";
  String groupValue = '';
  int currentIndex = 0;
  double quizProgress = 0.0;
  List<String> dataList = [];

  final translationController = Get.put(TranslationControllre());
  
  Future<void> fetchSuggestions(String query, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://admin.horumarkaal.app/api/app/search-translate'),
        headers: {
          'Authorization':
              "Bearer ${StorageServices.to.getString(userToken)}", // Replace with your actual auth token
        },
        body: {
          'lang': query,
          // 'query': query,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> dataListFromApi = data['data'];

        dataList = dataListFromApi.cast<String>();
      } else {
        // Handle error
        print('API call failed');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during API call: $e');
    }
  }
  
  Future<void> fetchQuizData(List<String> word, String selectedLanguage) async {
    try {
      final response = await http.post(
        Uri.parse("https://admin.horumarkaal.app/api/app/get-questions"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              "Bearer ${StorageServices.to.getString(userToken)}", // Replace with your actual auth token
        },
        body: jsonEncode({'type': selectedLanguage, 'word': word}),
      );
      if (response.statusCode == 200) {
        quizData =
            List<Map<String, dynamic>>.from(json.decode(response.body)["data"]);
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

 List<String> Corrects = [];
  void handleAnswer(String answer) {
    selectedAnswers = answer;
  }

  void updateQuizProgress() {
    quizProgress = (currentIndex + 1) / quizData.length;
  }

  void nextQuestion() {
    if (selectedAnswers.isNotEmpty && currentIndex < quizData.length - 1) {
      currentIndex++;
      selectedAnswers = ''; // Reset selected answer for the next question
      updateQuizProgress();
    } else if (selectedAnswers.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Please Select atleast one');
      // Show an error message because no option is selected
      // showErrorDialog('Please select an answer before proceeding.');
    }
  }

  void submitQuiz(context) {
    if (selectedAnswers.isNotEmpty) {
      int correctAnswers = 0;
      int incorrectAnswers = 0;

      for (int i = 0; i < quizData.length; i++) {
        if (quizData[i]["correct"] == Corrects[i]) {
          correctAnswers++;
        } else {
          incorrectAnswers++;
        }
      }

      updateQuizProgress();
      // Display results or navigate to results screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0XFFB4ACFF),
            // title: Text('Quiz Results'),
            content: Container(
              width: 400,
              color: const Color(0XFFB4ACFF),
              child: Column(
                children: [
                  Container(
                    height: 153. h,
                    width: 189.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/fram.png",
                            ),
                            fit: BoxFit.contain)),
                  ),
                  Text(
                    ' ${(correctAnswers / quizData.length * 100).toStringAsFixed(1)}% Score',
                    style: TextStyle(
                        color: const Color(0xFF4209BB), fontSize: 30.sp),
                  ),
                  Text(
                    'Congratulation!'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Exam Completed Succesfully'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        "You Attempted questions".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "${quizData.length} \nand\n $correctAnswers ",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "are answered correct.".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(msg: 'Please Select atleast one');
    }
    // Calculate and display results here
  }

 
  void calculateResults() {
    int correctAnswers = 0;
    int incorrectAnswers = 0;

    for (int i = 0; i < quizData.length; i++) {
      if (quizData[i]["correct"] == Corrects[i]) {
        correctAnswers++;
      } else {
        incorrectAnswers++;
      }
      print(correctAnswers);
    }
  }
  void onSelectLanguage(String language) {
    selectedLanguage.value = language;

    Get.back();
  }

  var selectedLanguage = 'Select Language'.obs;

  TextEditingController searchController = TextEditingController();
}
