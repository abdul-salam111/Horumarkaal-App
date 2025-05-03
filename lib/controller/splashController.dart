import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multitranslation/controller/settingsController.dart';
import 'package:multitranslation/loginPage.dart';
import 'package:multitranslation/selectLanguage.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';

class SplashController extends GetxController {
  final controller = Get.put(SettingsController());
  Future getPaymentStatus() async {
    try {
      final response = await http.get(
          Uri.parse("https://admin.horumarkaal.app/api/auth/getstatus"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                "Bearer ${StorageServices.to.getString(userToken)}",
          });

      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        StorageServices.to.setString(
            key: "isPaid", value: data['user']['is_paid'].toString());
      } else {
        //  StorageServices.to.getString()
      }
    } catch (e) {
      print("not updated");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller.fetchSelectedLanguage();
    Timer(const Duration(seconds: 3), () {
      if (StorageServices.to.getString(userToken).isNotEmpty ){
            Get.offAll(() => const SelectLanguageScreen());
      }
      //     StorageServices.to.getString("isPaid") == '1') {
      //   Get.to(() => const SelectLanguageScreen());
      // } else if (StorageServices.to.getString(userToken).isNotEmpty &&
      //     StorageServices.to.getString("isPaid") == '0') {
      //   Get.to(() => const SelectLanguageScreen());
      // }
       else {
        Get.offAll(() =>  LoginScreen());
      }
    });
  }
}
