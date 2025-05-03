import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multitranslation/commonwidgets/languagebutton.dart';
import 'package:multitranslation/controller/loginController.dart';
import 'package:multitranslation/controller/selectedLangController.dart';
import 'package:multitranslation/controller/translationNewController.dart';
import 'package:multitranslation/database/database.dart';
import 'package:multitranslation/models/getAllTranslation.dart';

import 'package:multitranslation/profile.dart';

import 'package:multitranslation/quizez.dart';
import 'package:velocity_x/velocity_x.dart';

class MainTranslationPage extends StatefulWidget {
  const MainTranslationPage({super.key});

  @override
  State<MainTranslationPage> createState() => _MainTranslationPageState();
}

class _MainTranslationPageState extends State<MainTranslationPage> {
  MultilangualDatabase? multilangualDatabase;
  @override
  void initState() {
    super.initState();
    multilangualDatabase = MultilangualDatabase();
    multilangualDatabase!.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationNewController());
    final logincontroller = Get.put(LoginController());
    final selectedLangController = Get.put(SelectedLanguageController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () async {
                  Get.to(() => const QuizPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Border radius
                  ),
                  minimumSize: Size(20.w, 29.h), // Width and height
                ),
                child: Text(
                  'Exercise & Quizzes'.tr,
                  style:
                      const TextStyle(color: Color(0xFF573AF5), fontSize: 12),
                )),
            ElevatedButton(
              onPressed: () async {
                // Handle button press
                await logincontroller.logOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF832CE5), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Border radius
                ),
                minimumSize: Size(80.w, 29.h), // Width and height
              ),
              child: Text(
                'Log Out'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const UserDetailsScreen());
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF832CE5),
              child: Text(
                'P', // Display the user's initial
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          10.widthBox,
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => LanguageButton(
                  color: const Color(0xFF832CE5),
                  language: 'English',
                  isSelected: selectedLangController.selectedLanguage.value ==
                      'english',
                  onPressed: () async {
                    // selectedLangController.update();
                    // translationController.update();
                    selectedLangController.selectedLanguage.value = 'english';
                    translationController.dataList.clear();
                    // translationController.fetchSuggestions(
                    //     selectedLangController.selectedLanguage.value);
                    //     setState(() {

                    //     });
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Obx(
                () => LanguageButton(
                  color: const Color(0xFF832CE5),
                  language: 'Soomaali',
                  isSelected: selectedLangController.selectedLanguage.value ==
                      'soomaali',
                  onPressed: () {
                    // selectedLangController.update();
                    // translationController.update();
                    selectedLangController.selectedLanguage.value = 'soomaali';
                    // translationController.fetchSuggestions(
                    //     selectedLangController.selectedLanguage.value);
                    //       setState(() {

                    //     });
                    translationController.dataList.clear();
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Obx(
                () => LanguageButton(
                  language: 'Arabic',
                  color: const Color(0xFF832CE5),
                  isSelected:
                      selectedLangController.selectedLanguage.value == 'arabic',
                  onPressed: () {
                    // selectedLangController.update();
                    // translationController.update();
                    selectedLangController.selectedLanguage.value = 'arabic';
                    // translationController.fetchSuggestions(
                    //     selectedLangController.selectedLanguage.value);
                    //       setState(() {

                    //     });
                    translationController.dataList.clear();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    controller: translationController.searchController.value,
                    onChanged: (val) {
                      translationController.searchSingleWord.value = val;
                      translationController.searchOneWord(
                          selectedLangController.selectedLanguage.value, val);
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (translationController
                              .searchController.value.text.isNotEmpty) {
                            // translationController.(
                            //     selectedLangController.selectedLanguage.value);
                          }
                          translationController.isSearch.value = true;
                        },
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide:
                              BorderSide(color: Color(0xFF832CE5), width: 2)),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Color(0xFF832CE5))),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Color(0xFF832CE5))),
                      hintText: 'Search'.tr,
                    ),
                    onTap: () async {
                      translationController.isSearch.value = true;
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (translationController.dataList.isNotEmpty) {
                      await translationController
                          .getTranslation(
                            translationController.dataList,
                            selectedLangController.selectedLanguage.value,
                          )
                          .then((value) => FocusScope.of(context).unfocus());
                    }
                    else{
                      Get.snackbar("", "Please select any word");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF832CE5), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Border radius
                    ),
                    minimumSize: Size(80.w, 40.h), // Width and height
                  ),
                  child: Text(
                    'Search'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => translationController.isSearch.value
              ? translationController.searchSingleWord.value.isNotEmpty
                  ? SizedBox(
                      height: 300.h,
                      child: Obx(
                        () => FutureBuilder(
                            future: translationController.searchOneWord(
                                selectedLangController.selectedLanguage.value,
                                translationController.searchSingleWord.value),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("No data found"),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: translationController
                                    .suggestionsList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(translationController
                                        .suggestionsList[index]),
                                    onTap: () {
                                      // translationController.getTranslation(
                                      //     translationController.dataList,
                                      //     selectedLangController
                                      //         .selectedLanguage.value);
                                      if (translationController.dataList
                                          .contains(translationController
                                              .suggestionsList[index])) {
                                        translationController.dataList.remove(
                                            translationController
                                                .suggestionsList[index]);
                                      } else {
                                        translationController.dataList.add(
                                            translationController
                                                .suggestionsList[index]);
                                      }
                                    },
                                    trailing: Obx(
                                      () => Checkbox(
                                          value: translationController.dataList
                                                  .contains(
                                                      translationController
                                                              .suggestionsList[
                                                          index])
                                              ? true
                                              : false,
                                          onChanged: (val) {
                                            if (translationController.dataList
                                                .contains(translationController
                                                    .suggestionsList[index])) {
                                              translationController.dataList
                                                  .remove(translationController
                                                      .suggestionsList[index]);
                                            } else {
                                              translationController.dataList
                                                  .add(translationController
                                                      .suggestionsList[index]);
                                              // translationController
                                              //     .insertHistory(
                                              //         HistoryModelForLocal(
                                              //   userId: StorageServices.to
                                              //       .getString(userId),
                                              //   selectedLanguage:
                                              //       selectedLangController
                                              //           .selectedLanguage.value,
                                              //   translation1: selectedLangController
                                              //               .selectedLanguage
                                              //               .value ==
                                              //           "english"
                                              //       ? translationController
                                              //           .wordsList[index].arabic
                                              //       : selectedLangController
                                              //                   .selectedLanguage
                                              //                   .value ==
                                              //               "soomaali"
                                              //           ? translationController
                                              //               .wordsList[index]
                                              //               .english
                                              //           : translationController
                                              //               .wordsList[index]
                                              //               .arabic,
                                              //   translation2: selectedLangController
                                              //               .selectedLanguage
                                              //               .value ==
                                              //           "english"
                                              //       ? translationController
                                              //           .wordsList[index]
                                              //           .soomaali
                                              //       : selectedLangController
                                              //                   .selectedLanguage
                                              //                   .value ==
                                              //               "soomaali"
                                              //           ? translationController
                                              //               .wordsList[index]
                                              //               .arabic
                                              //           : translationController
                                              //               .wordsList[index]
                                              //               .soomaali,
                                              //   searchedWord:
                                              //       translationController
                                              //           .suggestionsList[index],
                                              // ));
                                            }
                                          }),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    )
                  : SizedBox(
                      height: 300.h,
                      child: Obx(
                        () => FutureBuilder(
                            future: translationController.fetchSuggestions(
                                selectedLangController.selectedLanguage.value),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("No data found"),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: translationController
                                    .suggestionsList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(translationController
                                        .suggestionsList[index]),
                                    onTap: () {
                                      // translationController.getTranslation(
                                      //     translationController.dataList,
                                      //     selectedLangController
                                      //         .selectedLanguage.value);
                                      if (translationController.dataList
                                          .contains(translationController
                                              .suggestionsList[index])) {
                                        translationController.dataList.remove(
                                            translationController
                                                .suggestionsList[index]);
                                      } else {
                                        translationController.dataList.add(
                                            translationController
                                                .suggestionsList[index]);
                                      }
                                    },
                                    trailing: Obx(
                                      () => Checkbox(
                                          value: translationController.dataList
                                                  .contains(
                                                      translationController
                                                              .suggestionsList[
                                                          index])
                                              ? true
                                              : false,
                                          onChanged: (val) {
                                            if (translationController.dataList
                                                .contains(translationController
                                                    .suggestionsList[index])) {
                                              translationController.dataList
                                                  .remove(translationController
                                                      .suggestionsList[index]);
                                            } else {
                                              translationController.dataList
                                                  .add(translationController
                                                      .suggestionsList[index]);
                                              //  translationController
                                              //       .insertHistory(
                                              //           );

                                              // print(StorageServices.to
                                              //         .getString(userId));
                                              //         print(selectedLangController
                                              //                 .selectedLanguage
                                              //                 .value ==
                                              //             "english"
                                              //         ? translationController
                                              //             .dataList[index].arabic
                                              //         : selectedLangController
                                              //                     .selectedLanguage
                                              //                     .value ==
                                              //                 "soomaali"
                                              //             ? translationController
                                              //                 .wordsList[index]
                                              //                 .english
                                              //             : translationController
                                              //                 .wordsList[index]
                                              //                 .arabic);
                                              //   print(selectedLangController
                                              //             .selectedLanguage
                                              //             .value ==
                                              //         "english"
                                              //     ? translationController
                                              //         .wordsList[index]
                                              //         .soomaali
                                              //     : selectedLangController
                                              //                 .selectedLanguage
                                              //                 .value ==
                                              //             "soomaali"
                                              //         ? translationController
                                              //             .wordsList[index]
                                              //             .arabic
                                              //         : translationController
                                              //             .wordsList[index]
                                              //             .soomaali);
                                              // print(translationController
                                              //         .suggestionsList[index]);
                                              // print(HistoryModelForLocal(
                                              //       userId: StorageServices.to
                                              //           .getString(userId),
                                              //       selectedLanguage:
                                              //           selectedLangController
                                              //               .selectedLanguage.value,
                                              //       translation1: selectedLangController
                                              //                   .selectedLanguage
                                              //                   .value ==
                                              //               "english"
                                              //           ? translationController
                                              //               .wordsList[index].arabic
                                              //           : selectedLangController
                                              //                       .selectedLanguage
                                              //                       .value ==
                                              //                   "soomaali"
                                              //               ? translationController
                                              //                   .wordsList[index]
                                              //                   .english
                                              //               : translationController
                                              //                   .wordsList[index]
                                              //                   .arabic,
                                              //       translation2: selectedLangController
                                              //                   .selectedLanguage
                                              //                   .value ==
                                              //               "english"
                                              //           ? translationController
                                              //               .wordsList[index]
                                              //               .soomaali
                                              //           : selectedLangController
                                              //                       .selectedLanguage
                                              //                       .value ==
                                              //                   "soomaali"
                                              //               ? translationController
                                              //                   .wordsList[index]
                                              //                   .arabic
                                              //               : translationController
                                              //                   .wordsList[index]
                                              //                   .soomaali,
                                              //       searchedWord:
                                              //           translationController
                                              //               .suggestionsList[index],
                                              //     ).toJson());
                                            }
                                          }),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    )
              : Expanded(child: Container())),
          Obx(
            () => translationController.dataList.isNotEmpty
                ? FutureBuilder(
                    future: translationController.getTranslation(
                        translationController.dataList,
                        selectedLangController.selectedLanguage.value),
                    builder: (context,
                        AsyncSnapshot<List<GetAllTranslation>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No data found"),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(
                            () => Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.all(16),
                              color: const Color(0xFFB4ACFF),
                              child: Column(
                                children: [
                                  10.heightBox,
                                  selectedLangController
                                              .selectedLanguage.value ==
                                          "english"
                                      ? const Text(
                                          "Soomaali",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : selectedLangController
                                                  .selectedLanguage.value ==
                                              "soomaali"
                                          ? const Text(
                                              "English",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : selectedLangController
                                                      .selectedLanguage.value ==
                                                  "arabic"
                                              ? const Text(
                                                  "English",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              : const Text(""),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        // final word = translationController
                                        //     .translationsData!.keys
                                        //     .elementAt(index);

                                        // final translations =
                                        //     translationController.translationsData![word];

                                        return Row(
                                          children: [
                                            selectedLangController
                                                        .selectedLanguage
                                                        .value ==
                                                    "english"
                                                ? Expanded(
                                                    child: Text(
                                                    snapshot
                                                        .data![index].soomaali!,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ))
                                                : selectedLangController
                                                            .selectedLanguage
                                                            .value ==
                                                        "soomaali"
                                                    ? Expanded(
                                                        child: Text(
                                                        snapshot.data![index]
                                                            .english!,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ))
                                                    : selectedLangController
                                                                .selectedLanguage
                                                                .value ==
                                                            "arabic"
                                                        ? Expanded(
                                                            child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .english!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ))
                                                        : const Text(""),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon:
                                                    const Icon(Icons.volume_up),
                                                onPressed: () {
                                                  selectedLangController
                                                              .selectedLanguage
                                                              .value ==
                                                          "english"
                                                      ? translationController
                                                          .textToSpeech(
                                                              textToSpeak:
                                                                  translationController
                                                                      .wordsList[
                                                                          index]
                                                                      .soomaali!)
                                                      // speak(
                                                      //     translations['soomaali'], "so-SO")
                                                      : selectedLangController
                                                                  .selectedLanguage
                                                                  .value ==
                                                              "soomaali"
                                                          ? translationController
                                                              .speak(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .english!,
                                                                  "en-US")
                                                          : selectedLangController
                                                                      .selectedLanguage
                                                                      .value ==
                                                                  "arabic"
                                                              ? translationController.speak(
                                                                  translationController
                                                                      .wordsList[
                                                                          index]
                                                                      .english!,
                                                                  "en-US")
                                                              : const Text(
                                                                  ""); // Replace with your dynamic text
                                                },
                                                // child: Text('Play Audio'),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.all(16),
                              color: const Color(0xFFE1C7FF),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                          onTap: () {
                                            translationController.dataList
                                                .clear();
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 15.sp,
                                          ))),
                                  selectedLangController
                                              .selectedLanguage.value ==
                                          "english"
                                      ? const Text(
                                          "Arabic",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : selectedLangController
                                                  .selectedLanguage.value ==
                                              "soomaali"
                                          ? const Text(
                                              "Arabic",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : selectedLangController
                                                      .selectedLanguage.value ==
                                                  "arabic"
                                              ? const Text(
                                                  "Soomaali",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              : const Text(""),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            selectedLangController
                                                        .selectedLanguage
                                                        .value ==
                                                    "english"
                                                ? Expanded(
                                                    child: Text(
                                                    snapshot
                                                        .data![index].arabic!,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ))
                                                : selectedLangController
                                                            .selectedLanguage
                                                            .value ==
                                                        "soomaali"
                                                    ? Expanded(
                                                        child: Text(
                                                        snapshot.data![index]
                                                            .arabic!,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ))
                                                    : selectedLangController
                                                                .selectedLanguage
                                                                .value ==
                                                            "arabic"
                                                        ? Expanded(
                                                            child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .soomaali!,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ))
                                                        : const Text(""),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon:
                                                    const Icon(Icons.volume_up),
                                                onPressed: () {
                                                  selectedLangController
                                                              .selectedLanguage
                                                              .value ==
                                                          "english"
                                                      ? translationController
                                                          .speak(
                                                              snapshot
                                                                  .data![index]
                                                                  .arabic!,
                                                              "ar")
                                                      : selectedLangController
                                                                  .selectedLanguage
                                                                  .value ==
                                                              "soomaali"
                                                          ? translationController
                                                              .speak(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .arabic!,
                                                                  "ar")
                                                          : selectedLangController
                                                                      .selectedLanguage
                                                                      .value ==
                                                                  "arabic"
                                                              ? translationController
                                                                  .textToSpeech(
                                                                  textToSpeak: snapshot
                                                                      .data![
                                                                          index]
                                                                      .soomaali!,
                                                                )
                                                              : const Text(
                                                                  ""); // Replace with your dynamic text
                                                },
                                                // child: Text('Play Audio'),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    })
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}














// // ... (imports)

// class SearchScreen extends StatefulWidget {
//   final String selectedLanguage;
//   final String token;

//   SearchScreen({required this.selectedLanguage, required this.token});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController searchController = TextEditingController();
//   List<String> searchResults = [];
//   Map<String, dynamic> translations = {};

//   Future<void> _searchTranslate(String word, String lang) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://translation.saeedantechpvt.com/api/app/search-translate'),
//         headers: {'Authorization': 'Bearer ${widget.token}'},
//         body: {'lang': lang, 'word': word},
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         final Map<String, dynamic> translationsData = data['data']['translations'];

//         setState(() {
//           translations = translationsData;
//         });
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to get translations. Please try again.');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error during translation. Please try again.');
//     }
//   }

//   Future<void> _getTranslation(String word, String lang) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://translation.saeedantechpvt.com/api/app/get-translate'),
//         headers: {'Authorization': 'Bearer ${widget.token}'},
//         body: {'lang': lang, 'word': word},
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         final Map<String, dynamic> translationsData = data['data']['translations'];

//         setState(() {
//           translations = translationsData;
//         });
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to get translation. Please try again.');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error during translation. Please try again.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search and Translate'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: (value) {
//                 setState(() {
//                   searchResults.clear();
//                 });
//               },
//               onSubmitted: (value) {
//                 if (value.isNotEmpty) {
//                   _searchTranslate(value, widget.selectedLanguage);
//                 }
//               },
//               decoration: InputDecoration(
//                 hintText: 'Enter a word...',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     if (searchController.text.isNotEmpty) {
//                       _searchTranslate(searchController.text, widget.selectedLanguage);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: searchResults.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(searchResults[index]),
//                   onTap: () {
//                     _getTranslation(searchResults[index], widget.selectedLanguage);
//                   },
//                 );
//               },
//             ),
//           ),
//           if (translations.isNotEmpty)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   color: Colors.blue,
//                   child: Column(
//                     children: [
//                       Text(translations['soomaali'] != null ? 'Soomaali' : ''),
//                       Text(translations['soomaali'] ?? ''),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   color: Colors.green,
//                   child: Column(
//                     children: [
//                       Text(translations['arabic'] != null ? 'Arabic' : ''),
//                       Text(translations['arabic'] ?? ''),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
