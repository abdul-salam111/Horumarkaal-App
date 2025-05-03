import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multitranslation/controller/translationNewController.dart';

import 'package:multitranslation/historymodel.dart';
import 'package:multitranslation/models/historyModel.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';
import 'package:velocity_x/velocity_x.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(TranslationNewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("History"),
        ),
        body: Center(
            child: FutureBuilder(
          future: controller
              .getLocalHistory(int.parse(StorageServices.to.getString(userId))),
          builder:
              (context, AsyncSnapshot<List<HistoryModelForLocal>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading data"),
              );
            } else if (snapshot.data == null || snapshot.data == null) {
              return const Center(
                child: Text("No data available"),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!
                        .map((item) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.heightBox,
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 14),
                                  child: Text(
                                    formatDate(
                                      item.createdAt.toString(),
                                    ),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(snapshot.data!.length,
                                      (index) {
                                    String selectedLangString = snapshot
                                        .data![index].selectedLanguage
                                        .toString()
                                        .toLowerCase();

                                    return Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Selected Language: $selectedLangString",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "Word: ${snapshot.data![index].searchedWord}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "trans 1: ${snapshot.data![index].translation1}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "trans 2: ${snapshot.data![index].translation2}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ))
                        .toList()),
              );
            }
          },
        )));
  }

  Future<HistoryModel> fetchHistoryData(String token) async {
    final response = await http.post(
      Uri.parse('https://admin.horumarkaal.app/api/app/get-user-search-history'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${StorageServices.to.getString(userToken)}', // Use the passed token here
      },
    );

    if (response.statusCode == 200) {
      return HistoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load history');
    }
  }

  String formatDate(String inputDate) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the date as "27-Mar-2024"
    String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);

    return formattedDate;
  }
}
