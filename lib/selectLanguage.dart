import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multitranslation/commonwidgets/languagebutton.dart';
import 'package:multitranslation/controller/selectedLangController.dart';
import 'package:multitranslation/database/database.dart';
import 'package:multitranslation/models/getAllTranslation.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';
import 'package:multitranslation/translationPage.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  MultilangualDatabase? multilangualDatabase;
  List<GetAllTranslation>? translation;

  @override
  void initState() {
    // TODO: implement initStatee
    super.initState();
    multilangualDatabase = MultilangualDatabase();
    multilangualDatabase!.initializeDatabase();
    checkInternetConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final controllre = Get.put(SelectedLanguageController());
    controllre.selectedLanguage.value = "english";
    // fetchDataToStoreInMySql();
    return Scaffold(
      backgroundColor: const Color(0xFF832CE5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              10.heightBox,
              Text(
                'Multilingual Glossary App',
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => LanguageButton(
                      color: Colors.white,
                      language: 'English',
                      isSelected:
                          controllre.selectedLanguage.value == 'english',
                      onPressed: () {
                        controllre.selectedLanguage.value = 'english';
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Obx(
                    () => LanguageButton(
                      color: Colors.white,
                      language: 'Soomaali',
                      isSelected:
                          controllre.selectedLanguage.value == 'soomaali',
                      onPressed: () {
                        controllre.selectedLanguage.value = 'soomaali';
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Obx(
                    () => LanguageButton(
                      color: Colors.white,
                      language: 'Arabic',
                      isSelected: controllre.selectedLanguage.value == 'arabic',
                      onPressed: () {
                        controllre.selectedLanguage.value = 'arabic';
                      },
                    ),
                  ),
                ],
              ),
              10.heightBox,
              Container(
                width: 150.w,
                height: 150.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/applogo.png"),
                  ),
                ),
              ),
              Text(
                "Horumarkaal App",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp),
              ),
              20.heightBox,
              SizedBox(height: 5.h),
              const Text(
                "HORUMARKAAL APP (Ver. 01 - year 2024)",
                style: TextStyle(color: Colors.white),
              ),
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Horumarkaal is a multilingual glossary app designed by language experts to help Somali speaking students and individuals to overcome language barriers and learn English language. The glossary app enable user instant access to more than 150,000 technical terms covering key major educational field such as chemistry, biology, physics, math, geography, engineering, law, Artificial Intelligence AI, health, IT & computer, courts & Justice, environment, philanthropy and NGO’s, media, communication, banking, logistic, astronomy, agriculture, vocational training, project management, environmental protection, tourism, labour, commerce, industry and other related professions.",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
              )),
              ElevatedButton(
                onPressed: () {
                  if (controllre.selectedLanguage.value.isNotEmpty) {
                    Get.to(() => const MainTranslationPage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Border radius
                  ),
                  minimumSize: Size(299.w, 39.h), // Width and height
                ),
                child: const Text(
                  'Next Page',
                  style: TextStyle(
                    color: Color(0xFF832CE5),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future fetchDataToStoreInMySql() async {
    try {
      EasyLoading.show();
      List<GetAllTranslation> lengths =
          await multilangualDatabase!.getAllTranslations();

      final response = await http.post(
        Uri.parse(
            'https://admin.horumarkaal.app/api/app/get-all-translate?length=${lengths.length}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer ${StorageServices.to.getString(userToken)}", // Replace wsith your actual auth token
        },
      );
  
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['data'].length == 0) {
          EasyLoading.dismiss();
        } else {
          EasyLoading.show(status: "Please wait...");
          List<GetAllTranslation> listOfWords = [];
          await multilangualDatabase!.clearTable();

          for (var i = 0; i < data['data'].length; i++) {
            listOfWords.add(GetAllTranslation.fromJson(data['data'][i]));

            await multilangualDatabase!.insertDataToDictionary(listOfWords[i]);
          }
          EasyLoading.dismiss();
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      // Handle exceptions
      EasyLoading.dismiss();
      print('Exception during API call: $e');
      throw Exception();
    }
  }

  checkInternetConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      fetchDataToStoreInMySql();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      fetchDataToStoreInMySql();
    }
  }
}
