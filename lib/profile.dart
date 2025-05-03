import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multitranslation/configuration/localization.dart';
import 'package:multitranslation/controller/settingsController.dart';
import 'package:multitranslation/forgetPassword.dart';
import 'package:multitranslation/history.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';
import 'package:velocity_x/velocity_x.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: const Color(0xFF4E3DF8),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4E3DF8),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 50.r,
              child: Center(
                child: Text(
                  " ${StorageServices.to.getString(userName).toString()[0].toUpperCase()}",
                  style: TextStyle(fontSize: 40.sp),
                ),
              ),
            ),
            20.heightBox,
            Text(
              StorageServices.to.getString(userName),
              style: const TextStyle(fontSize: 15),
            ),
            10.heightBox,
            Text(
              StorageServices.to.getString(userEmail),
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Column(
              children: [
                20.heightBox,
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  leading: const Icon(Icons.password),
                  title: const Text(
                    'Change Password',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                    );
                  },
                  leading: const Icon(Icons.history),
                  title: const Text(
                    'History',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                    );
                  },
                  leading: const Icon(Icons.language),
                  title: Text(
                    "Language".tr,
                  ),
                  trailing: Obx(() => DropdownButton<String>(
                        value: controller.selectedLanguage.value,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.changeLanguage(newValue);
                          }
                        },
                        items: LocalizationService.languages
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      )),
                ),
                200.heightBox,
              ],
            ).box.padding(const EdgeInsets.all(12)).topRounded().white.make()
          ],
        ),
      ),
    );
  }
}
