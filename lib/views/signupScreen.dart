import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pr_8_firebase/components/authcontroler.dart';
import 'package:pr_8_firebase/components/logsigncontrol.dart';

class SignupScreen extends StatelessWidget {
  final signUpController = Get.put(SignUpController());

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Center(
                child: Text(
              "Sign Up",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 26.h,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(height: 20.h),
            Text(
              "FULL NAME",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40.h,
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: controller.txtname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
                controller: controller.txtemail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "PHONE",
              style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40.h,
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: controller.txtmobile,
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
                  controller: controller.txtpass,
                  obscureText: !signUpController.isPasswordVisible.value,
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
            SizedBox(height: 20.h),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Text(
                    "Already have an account? Log in",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h),
                child: ElevatedButton(
                    onPressed: () {
                      controller.signUp(
                        controller.txtname.text,
                        controller.txtmobile.text,
                        controller.txtemail.text,
                        controller.txtpass.text,
                       );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 60.w, vertical: 10.h),
                      child: Text(
                        "Sign Up",
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
