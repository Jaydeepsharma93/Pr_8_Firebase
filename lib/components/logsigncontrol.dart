import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var agreeToTerms = false.obs;
}


class LoginController extends GetxController {
  final txtemail = TextEditingController();
  final txtpass = TextEditingController();
  var isPasswordVisible = false.obs;


  @override
  void dispose() {
    txtemail.dispose();
    txtpass.dispose();
    super.dispose();
  }
}