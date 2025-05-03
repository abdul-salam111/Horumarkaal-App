import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multitranslation/controller/loginController.dart';
import 'package:multitranslation/forgetPassword.dart';
import 'package:multitranslation/loginPage.dart';

class SignUpResponse {
  final bool success;
  final String message;

  SignUpResponse({required this.success, required this.message});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> signUpUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        EasyLoading.show(status: "Creating account...");
        final response = await http.post(
          Uri.parse(
            'https://admin.horumarkaal.app/api/auth/register',
          ),
          body: {
            'email': emailController.text,
            'firstname': firstNameController.text,
            'lastname': lastNameController.text,
            'password': passwordController.text
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          SignUpResponse signUpResponse = SignUpResponse.fromJson(data);
          print(response.body);
          if (signUpResponse.success) {
            final response = await http.post(
              Uri.parse(
                  'https://admin.horumarkaal.app/api/auth/password/forgot?email=${emailController.text}'),
            );

            if (response.statusCode == 200) {
              final Map<String, dynamic> data = json.decode(response.body);
              int id = data['data']['id'];
              bool success = data['success'];
              print(response.body);
              EasyLoading.dismiss();
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
            } else {
              EasyLoading.dismiss();
              Fluttertoast.showToast(
                  msg: 'Email, not found. Please register first.');
            }
          } else {
            EasyLoading.dismiss();
            Fluttertoast.showToast(
                msg: 'Login failed. Please check your credentials.');
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
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 162.h,
                      width: 182.w,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/pik.png",
                              ),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: Colors.black),
                    controller: firstNameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(
                          Icons.person,
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
                        hintText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      // Check if the value contains only alphabets and spaces
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Please enter a valid first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: Colors.black),
                    controller: lastNameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(
                          Icons.person,
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
                        hintText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Please enter a valid last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
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
                  SizedBox(height: 16.h),
                  Obx(
                    () => TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller: passwordController,
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
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () async {
                      await signUpUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832CE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(double.infinity, 39.h),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account ? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "SignIn",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                              emailController.clear();
                              passwordController.clear();
                              firstNameController.clear();
                              lastNameController.clear();
                            },
                        ),
                      ],
                    ),
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
