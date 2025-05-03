import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multitranslation/controller/quizController.dart';
import 'package:multitranslation/controller/translationController.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'controller/userController.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final String apiUrl =
      "https://admin.horumarkaal.app/api/app/get-questions?word=help&type=english to soomaali";
  List<Map<String, dynamic>> quizData = [];
  String selectedAnswers = "";
  String selectedAnswerss = "";
  String groupValue = '';
  int currentIndex = 0;
  double quizProgress = 0.0;
  List<String> dataList = [];
  @override
  void initState() {
    super.initState();
    // fetchQuizData();
  }

  final userController = Get.put(UserController());
  Future<void> _fetchSuggestions(String query, String token) async {
    print(token);
    print(query);
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

        setState(() {
          dataList = dataListFromApi.cast<String>();
        });
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
        setState(() {
          quizData = List<Map<String, dynamic>>.from(
              json.decode(response.body)["data"]);
        });
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  List<String> Corrects = [];
  void handleAnswer(String answer) {
    setState(() {
      selectedAnswers = answer;
    });
  }

  void updateQuizProgress() {
    setState(() {
      quizProgress = (currentIndex + 1) / quizData.length;
    });
  }

  void nextQuestion() {
    if (selectedAnswers.isNotEmpty && currentIndex < quizData.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswers = ''; // Reset selected answer for the next question
        updateQuizProgress();
      });
    } else if (selectedAnswers.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Please Select atleast one');
      // Show an error message because no option is selected
      // showErrorDialog('Please select an answer before proceeding.');
    }
  }

  void submitQuiz() {
    if (selectedAnswers.isNotEmpty) {
      int correctAnswers = 0;
      int incorrectAnswers = 0;

      for (int i = 0; i < quizData.length; i++) {
        print(quizData);
        print(Corrects);
        if (quizData[i]["correct"] == Corrects[i]) {
          correctAnswers++;
        } else {
          incorrectAnswers++;
        }
        print(correctAnswers);
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
                    height: 153.h,
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

  void _showLanguageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LanguageOption('english to soomaali', onSelectLanguage),
              LanguageOption('english to arabic', onSelectLanguage),
              LanguageOption('arabic to english', onSelectLanguage),
              LanguageOption('arabic to soomaali', onSelectLanguage),
              LanguageOption('soomaali to english', onSelectLanguage),
              LanguageOption('soomaali to arabic', onSelectLanguage),
            ],
          ),
        );
      },
    );
  }

  void onSelectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
    Navigator.of(context).pop();
  }

  String selectedLanguage = 'Select Language';

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final quizController = Get.put(QuizController());
    final translationController = Get.put(TranslationControllre());
    // if (quizData.isEmpty) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Loading...'),
    //     ),
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    //  else {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text('Quiz'),
      //   elevation: 0.0,
      //   backgroundColor: ,
      // ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF832CE5), // Top color (#832CE5)
                Color(0xFF4E3DF8), // Bottom color (#4E3DF8)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 340.w,
                  height: 30.h,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLanguageOptions(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(selectedLanguage),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     border: Border.all(
                    //       width: 1.w,
                    //       color: const Color(0xFF832CE5),
                    //     ),
                    //   ),
                    //   width: 360.w,
                    //   height: 34.h,
                    //   child: TextField(
                    //     style: const TextStyle(color: Colors.black),
                    //     controller: searchController,
                    //     decoration: InputDecoration(
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       hintText: 'Search'.tr,
                    //       border: InputBorder.none,
                    //       suffixIcon: IconButton(
                    //         icon: const Icon(Icons.search),
                    //         onPressed: () {
                    //           if (searchController.text.isNotEmpty) {
                    //             setState(() {
                    //               dataList.length = 0;
                    //             });
                    //             //   fetchExactTranslation(searchController.text, widget.selectedLanguage,widget.token!);
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //     onTap: () {
                    //       print(selectedLanguage);
                    //       _fetchSuggestions(selectedLanguage, StorageServices.to.getString(userToken));
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await fetchQuizData(
                                translationController.words, selectedLanguage);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF832CE5), // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0), // Border radius
                            ),
                            // Width and height
                          ),
                          child: Text(
                            'Quiz by Words'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            //  dataList = 0;
                            // await  _getTranslation(userController.words.value, widget.selectedLanguage);
                            setState(() {
                              dataList.length = 0;
                            });

                            await fetchQuizData(translationController.nullList,
                                selectedLanguage);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF832CE5),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0), // Border radius
                            ),
                            // Width and height
                          ),
                          child: Text(
                            'All Quizez'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                dataList.isNotEmpty
                    ? SingleChildScrollView(
                        child: SizedBox(
                          height: 300,
                          width: 500,
                          child: ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  dataList[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  //   _getTranslation(dataList[index], widget.selectedLanguage);
                                },
                                trailing: Obx(
                                  () => Checkbox(
                                      value: translationController.words
                                              .contains(dataList[index])
                                          ? true
                                          : false,
                                      onChanged: (val) {
                                        if (translationController.words
                                            .contains(dataList[index])) {
                                          translationController.words
                                              .remove(dataList[index]);
                                        } else {
                                          translationController.words
                                              .add(dataList[index]);
                                        }
                                      }),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                //    LinearProgressIndicator(
                //   value: quizProgress,
                //   backgroundColor: Colors.grey,
                //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                // ),
                const SizedBox(
                  height: 30,
                ),
                quizData.isEmpty
                    ? Container()
                    :
                    //if(selectedLanguage != "Select Language")
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LinearPercentIndicator(
                            width: 320.w,
                            lineHeight: 20.0,
                            percent: quizProgress,
                            center: Text(
                              ' ${(quizProgress * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: Colors.grey,
                            progressColor: Colors.blue,
                          ),
                          const SizedBox(
                            height: 50,
                          ),

                          Row(
                            children: [
                              Text(
                                'Question'.tr,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                ': ${currentIndex + 1}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "${quizData[currentIndex]["question"]}",
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 16),
                          // Column(
                          //   children: [
                          //     for (var i = 1; quizData[currentIndex]["answer_$i"] != null; i++)
                          //       RadioListTile<String>(
                          //         title: Text(quizData[currentIndex]["answer_$i"]),
                          //         value: "answer_$i",
                          //         groupValue: selectedAnswers.isNotEmpty ? selectedAnswers[0] : null,
                          //         onChanged: (value) => handleAnswer(value!),
                          //       ),
                          //   ],
                          // ),

                          Column(
                            children: [
                              for (var i = 1;
                                  quizData[currentIndex]["answer_$i"] != null;
                                  i++)
                                ChoiceRadio(
                                  text: quizData[currentIndex]["answer_$i"],
                                  value: quizData[currentIndex]["answer_$i"],
                                  groupValue: selectedAnswers.isNotEmpty
                                      ? selectedAnswers
                                      : null,
                                  onChanged: (value) => setState(() {
                                    selectedAnswers = value!;
                                    Corrects.add(value);
                                    print(selectedAnswers);
                                  }),
                                ),
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     for (String answer in [quizData[currentIndex]["answer_1"], quizData[currentIndex]["answer_2"]])
                          //       RadioListTile<String>(
                          //       //  selected: true,
                          //         activeColor: Colors.white,
                          //         title: Text(answer,style: TextStyle(color: Colors.white),),
                          //         value: answer,
                          //         groupValue: selectedAnswerss,
                          //         onChanged: (value) => handleAnswer(value!),
                          //       ),
                          //   ],
                          // ),

                          //       ElevatedButton(
                          //   onPressed: () {
                          //     if (selectedAnswers.isNotEmpty) {
                          //       if (currentIndex < quizData.length - 1) {
                          //         setState(() {
                          //           currentIndex++;
                          //           selectedAnswers = "";
                          //         });
                          //       } else {
                          //         // Calculate and display results
                          //         calculateResults();
                          //       }
                          //     } else {
                          //       // Show an error message because no option is selected
                          //    //   showErrorDialog('Please select an answer before proceeding.');
                          //     }
                          //   },
                          //   child: Text(currentIndex < quizData.length - 1 ? 'Next' : 'Submit'),
                          // ),
                          const SizedBox(height: 16),
                          if (currentIndex < quizData.length - 1)
                            ElevatedButton(
                              onPressed: nextQuestion,
                              child: Text('Next'.tr),
                            )
                          else
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: submitQuiz,
                                  child: Text('Submit'.tr),
                                ),
                                // ElevatedButton(
                                //   onPressed: submitQuiz,
                                //   child: Text('Next Question'),
                                // ),
                              ],
                            ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
    //}
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final Function(String) onSelect;

  const LanguageOption(this.language, this.onSelect, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language),
      onTap: () {
        onSelect(language);
      },
    );
  }
}

class ChoiceRadio<T> extends StatelessWidget {
  final String text;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  const ChoiceRadio({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.white,
        ),
        Text(text),
      ],
    );
  }
}
