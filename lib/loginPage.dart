import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multitranslation/const.dart';
import 'package:multitranslation/controller/loginController.dart';
import 'package:multitranslation/forgetPassword.dart';
import 'package:multitranslation/signUp.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();

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
                      height: 212.h,
                      width: 182.w,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/pik.png",
                              ),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 17.sp),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the sign-up page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  const SignUpScreen()),
                              );
                              controller.emailController.value.clear();
                              controller.passwordController.value.clear();
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
                    controller: controller.emailController.value,
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
                  SizedBox(
                    height: 20.h,
                  ),
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
                  SizedBox(height: 5.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Get.to(() => const ForgotPasswordScreen());
                          controller.emailController.value.clear();
                          controller.passwordController.value.clear();
                        },
                        child: Text(
                          "Forget Password",
                          style: TextStyle(color: color),
                        )),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate the form and login if valid
                      if (_formKey.currentState?.validate() ?? false) {
                        await controller.login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832CE5), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Border radius
                      ),
                      minimumSize:
                          Size(double.infinity, 39.h), // Width and height
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
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
