import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multitranslation/controller/loginController.dart';
import 'package:multitranslation/loginPage.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> sendOtp() async {
    EasyLoading.show(status: "Please wait...");
    StorageServices.to.setString(key: userEmail, value: emailController.text);
    final response = await http.post(
      Uri.parse(
          'https://admin.horumarkaal.app/api/auth/password/forgot?email=${emailController.text}'),
    );
print(response.body);
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
        Get.to(() => VerifyOtpScreen(userId: id));
        Fluttertoast.showToast(
            msg: "We sent otp to your email, please check your email.");
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: 'Email, not found. Please register first.');
      }
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Email, not found. Please register first.');
    }
    // Parse the response and handle accordingly
    // ...

    // For demonstration purposes, assuming the API returns an 'id' in the response
    // int userId = 3; // Replace with the actual user id from the response

    // // Navigate to the next screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VerifyOtpScreen(userId: userId),
    //   ),
    // );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  controller: emailController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF832CE5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide:
                              BorderSide(color: Color(0xFF832CE5), width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Color(0xFF832CE5))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(color: Color(0xFF832CE5))),
                      hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await sendOtp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF832CE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Send OTP',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyOtpScreen extends StatefulWidget {
  final int userId;

  const VerifyOtpScreen({super.key, required this.userId});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController otpController = TextEditingController();
  Future<void> verifyOtp() async {
    try {
      EasyLoading.show(status: "Verifying...");
      final response = await http.post(
        Uri.parse(
            'https://admin.horumarkaal.app/api/auth/otp/verify?user_id=${widget.userId}&otp=${otpController.text}'),
      );

      // Parse the response and handle accordingly
      // ...
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = await json.decode(response.body);
        String token = await data['data']['token'];
        bool success = await data['success'];
        EasyLoading.dismiss();
        if (success == true) {
          Get.to(() => ResetPasswordScreen(token: token));
        } else {
          EasyLoading.dismiss();

          Fluttertoast.showToast(msg: 'Failed to verify otp.');
        }
      } else {
        EasyLoading.dismiss();

        Fluttertoast.showToast(msg: 'Failed to verify otp.');
      }

      // For demonstration purposes, assuming the API returns a 'token' in the response
      // String token = 'your_token'; // Replace with the actual token from the response

      // // Navigate to the next screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ResetPasswordScreen(token: token),
      //   ),
      // );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: const Color(0xFF832CE5)),
                ),
                width: 299.w,
                height: 44.h,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: otpController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 13),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF832CE5)),
                    border: InputBorder.none,
                    hintText: 'Verify OTP',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await verifyOtp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF832CE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(299, 48),
                ),
                child: const Text('Verify OTP',
                    style: TextStyle(color: Colors.white)),
              ),
              10.heightBox,
              OtpTimerButton(
                buttonType: ButtonType.text_button,
                controller: controller,
                onPressed: () {
                  sendOtp();
                },
                text: const Text('Resend OTP'),
                duration: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    EasyLoading.show(status: "Please wait...");

    final response = await http.post(
      Uri.parse(
          'https://admin.horumarkaal.app/api/auth/password/forgot?email=${StorageServices.to.getString(userEmail)}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

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
        controller.startTimer();

        Fluttertoast.showToast(
            msg: "We sent otp to your email, please check your email.");
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: 'Email, not found. Please register first.');
      }
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Email, not found. Please register first.');
    }
  }

  OtpTimerButtonController controller = OtpTimerButtonController();
}

class VerifyOtpScreenForLogin extends StatefulWidget {
  final int userId;

  const VerifyOtpScreenForLogin({super.key, required this.userId});

  @override
  _VerifyOtpScreenForLoginState createState() =>
      _VerifyOtpScreenForLoginState();
}

class _VerifyOtpScreenForLoginState extends State<VerifyOtpScreenForLogin> {
  TextEditingController otpController = TextEditingController();
  Future<void> verifyOtp() async {
    try {
      EasyLoading.show(status: "Verifying...");
      final response = await http.post(
        Uri.parse(
            'https://admin.horumarkaal.app/api/auth/otp/verify?user_id=${widget.userId}&otp=${otpController.text}'),
      );

      // Parse the response and handle accordingly
      // ...
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = await json.decode(response.body);

        bool success = await data['success'];
        EasyLoading.dismiss();
        if (success == true) {
          Get.to(() => LoginScreen());
        } else {
          EasyLoading.dismiss();

          Fluttertoast.showToast(msg: 'Failed to verify otp.');
        }
      } else {
        EasyLoading.dismiss();

        Fluttertoast.showToast(msg: 'Failed to verify otp.');
      }

      // For demonstration purposes, assuming the API returns a 'token' in the response
      // String token = 'your_token'; // Replace with the actual token from the response

      // // Navigate to the next screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ResetPasswordScreen(token: token),
      //   ),
      // );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: const Color(0xFF832CE5)),
                ),
                width: 299.w,
                height: 44.h,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: otpController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF832CE5)),
                    border: InputBorder.none,
                    hintText: 'Verify OTP',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await verifyOtp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF832CE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(299, 39),
                ),
                child: const Text('Verify OTP',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final controller = Get.put(LoginController());

  Future<void> resetPassword() async {
    EasyLoading.show(status: "Please wait...");
    final response = await http.post(
      Uri.parse(
          'https://admin.horumarkaal.app/api/auth/password/reset?token=${widget.token}&password=${controller.passwordController.value.text}&password_confirmation=${controller.confirmController.value.text}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = await json.decode(response.body);
      //String token = data['data']['token'];
      bool success = await data['success'];
      EasyLoading.dismiss();
      if (success == true) {
        controller.passwordController.value.clear();
        controller.confirmController.value.clear();
        Get.to(() => LoginScreen());
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: 'Login failed. Please check your credentials.');
      }
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Api Error');
    }
    // Parse the response and handle accordingly
    // ...

    // For demonstration purposes, check if success is true
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: controller.passwordController.value,
                      obscureText: controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                controller.isPasswordVisible.value =
                                    !controller.isPasswordVisible.value;
                              },
                              child: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF832CE5),
                              )),
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF832CE5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                  color: Color(0xFF832CE5), width: 2)),
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
                          hintText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: controller.confirmController.value,
                      obscureText: controller.confirmPasswordVisible.value,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                controller.confirmPasswordVisible.value =
                                    !controller.confirmPasswordVisible.value;
                              },
                              child: Icon(
                                controller.confirmPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF832CE5),
                              )),
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF832CE5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                  color: Color(0xFF832CE5), width: 2)),
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
                          hintText: 'Confirm Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your confirm password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          controller.confirmController.value.text ==
                              controller.passwordController.value.text) {
                        await resetPassword();
                      } else if (controller.confirmController.value.text !=
                          controller.passwordController.value.text) {
                        Get.snackbar("Passwords not matched!",
                            "Passsword and confirm password does not matching!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832CE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Confirm',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
