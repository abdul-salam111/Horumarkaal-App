import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multitranslation/configuration/localization.dart';
//import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:multitranslation/storage/storage.dart';
import 'package:multitranslation/splashScreen.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  // MpesaFlutterPlugin.setConsumerKey(
  //     "B2qlFEVmMT5Ls2VtPwpveQdTE54bRtuQktBFGG51mS1ozU97");
  // MpesaFlutterPlugin.setConsumerSecret(
  //     "vtqKbajz1AwnPplw6mSGB5tLkuwjjlUQdyLkFDN94SCllw0ldc7B0ip5ruf6XOQP");

  await StorageServices.to.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            translations: LocalizationService(),
            fallbackLocale: const Locale("en", "US"),
            locale: Get.deviceLocale,
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
            builder: EasyLoading.init(),
          );
        },
        child: const SplashScreen());
  }
}
