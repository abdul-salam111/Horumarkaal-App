import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multitranslation/controller/settingsController.dart';
import 'package:multitranslation/controller/splashController.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: const Color(0xFF832CE5),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                40.heightBox,
                Text(
                  'Multilingual Glossary App',
                  style: TextStyle(fontSize: 25.sp),
                ),
                Container(
                  width: 400.w,
                  height: 250.w,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/image.png"))),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: const BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage("assets/1.png"))),
                ),
                Center(
                  child: Text(
                    "Hiigsikaal Platform \nMadasha Hiigsikaal \n     منصة هيغسيكال ",
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
