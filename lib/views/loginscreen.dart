import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pr_8_firebase/components/authcontroler.dart';
import 'package:pr_8_firebase/components/googleservice.dart';
import 'package:pr_8_firebase/components/logsigncontrol.dart';
import 'package:pr_8_firebase/views/userscreen.dart';

class LoginScreen extends StatelessWidget {
  final loginController = Get.put(LoginController());
  final authController = Get.put(AuthController());
  final signUpController = Get.put(SignUpController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Center(
                child: Text(
              "Log In",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 26.h,
                  fontWeight: FontWeight.w500),
            )),
            Text(
              "EMAIL",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40.h,
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: loginController.txtemail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "PASSWORD",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40.h,
              child: Obx(
                () => TextField(
                  textInputAction: TextInputAction.done,
                  obscureText: !signUpController.isPasswordVisible.value,
                  controller: loginController.txtpass,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          signUpController.isPasswordVisible.value =
                              !signUpController.isPasswordVisible.value;
                        },
                        icon: Icon(
                          signUpController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                Text(
                  "Save Login Info On Your Device",
                  style: TextStyle(fontSize: 13.h, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Text(
                    "Don't have an account? sign up",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: SignInButton(Buttons.Google,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                await GoogleLoginServices.googleLoginServices
                    .signInWithGoogle();
                if (FirebaseAuth.instance.currentUser != null) {
                  print(
                      'User signed in: ${FirebaseAuth.instance.currentUser!.email}');
                  Get.off(
                    UserScreen(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 500),
                  );
                } else {
                  print('No user signed in');
                }
              }),
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h),
                child: ElevatedButton(
                    onPressed: () {
                      authController.signIn(
                        loginController.txtemail.text,
                        loginController.txtpass.text,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 60.w, vertical: 10.h),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 20.h,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
