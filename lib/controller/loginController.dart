import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multitranslation/controller/settingsController.dart';
import 'package:multitranslation/controller/splashController.dart';
import 'package:multitranslation/forgetPassword.dart';
import 'package:multitranslation/loginPage.dart';
import 'package:multitranslation/selectLanguage.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';

class LoginController extends GetxController {
  var isPasswordVisible = true.obs;
  var confirmPasswordVisible = true.obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final confirmController = TextEditingController().obs;
  final controller = Get.put(SettingsController());
  final splashcontroller = Get.put(SplashController());

  Future<void> login() async {
    if (!_validateFields()) {
      return;
    }

    try {
      EasyLoading.show(status: "Please wait...");
      final response = await http.post(
        Uri.parse(
          'https://admin.horumarkaal.app/api/auth/login?email=${emailController.value.text}&password=${passwordController.value.text}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data']['user']['email_verified_at'] != null) {
          final String token = data['data']['token'];

          final Map<String, dynamic> userData = data['data']['user'];
          StorageServices.to.setString(
              key: userName,
              value: userData['firstname'] + userData['lastname']);
          StorageServices.to
              .setString(key: userEmail, value: userData['email']);

          StorageServices.to.setString(key: userToken, value: token);
          Get.offAll(() => const SelectLanguageScreen());
          EasyLoading.dismiss();
        } else {
          Get.snackbar("Not verified", "Email not verified.");
          final response = await http.post(
            Uri.parse(
                'https://admin.horumarkaal.app/api/auth/password/forgot?email=${emailController.value.text}'),
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = json.decode(response.body);
            int id = data['data']['id'];
            bool success = data['success'];
            EasyLoading.dismiss();
            // final String message = data['success'];
            //  final String messages = data['success'];

            // final Map<String, dynamic> userData = data['data']['user'];
            // Login successful, redirect to splash screen
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => LoginScreen()),
            // );
            // print(message);
            if (success == true) {
              EasyLoading.dismiss();
              Get.to(() => VerifyOtpScreenForLogin(userId: id));
              Fluttertoast.showToast(
                  msg: "We sent otp to your email, please check your email.");
            } else {
              EasyLoading.dismiss();
              Fluttertoast.showToast(
                  msg: 'Email, not found. Please register first.');
            }
          }
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: 'Login failed. Please check your credentials.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Error during login. Please try again.');
    }
  }

  bool _validateFields() {
    if (emailController.value.text.isEmpty ||
        passwordController.value.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all required fields');
      return false;
    }

    return true;
  }

  Future<void> logOut() async {
    try {
      EasyLoading.show(
        status: "Please wait...",
      );
      final response = await http.get(
        Uri.parse(
          'https://admin.horumarkaal.app/api/auth/logout',
        ),
        headers: {
          'Authorization': "Bearer ${StorageServices.to.getString(userToken)}",
        },
      );

      Get.to(() =>  LoginScreen());
      if (response.statusCode == 200) {
        await StorageServices.to.remove(userToken);
        EasyLoading.dismiss();
        Get.offAll(() =>  LoginScreen());
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: 'Login failed. Please check your credentials.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Error during login. Please try again.');
    }
  }
}
