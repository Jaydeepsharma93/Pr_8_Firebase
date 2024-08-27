import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pr_8_firebase/components/authservice.dart';
import 'package:pr_8_firebase/components/googleservice.dart';

class AuthController extends GetxController {

  // Controllers for text fields
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpass = TextEditingController();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtmobile = TextEditingController();

  // Observables for user details
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString mobile = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  /// Fetches the user's details and updates the observables.
  void getUserDetails() {
    User? user = GoogleLoginServices.googleLoginServices.currentUser();
    if (user != null) {
      email.value = user.email ?? 'No email';
      name.value = user.displayName ?? "User name";
      mobile.value = user.phoneNumber ?? "No number";
      logUserDetails();
    }
  }

  /// Logs the current user details.
  void logUserDetails() {
    log('-----------------------------------');
    log('Email: ${email.value}');
    log('Name: ${name.value}');
    log('Mobile: ${mobile.value}');
  }

  /// Handles user sign-up.
  Future<void> signUp(
      String name, String mobile, String email, String password) async {
    try {
      bool emailExists =
      await FirebaseAuthServices.authServices.checkEmailExists(email);
      log("Email Exists: $emailExists");

      if (emailExists) {
        showSnackbar(
          'Sign Up Failed',
          'Email already in use. Please use a different email.',
          Colors.red,
        );
      } else {
        await FirebaseAuthServices.authServices
            .createAccountUsingEmail(email, password, name, mobile)
            .then(
              (value) {
            showSnackbar(
              'Sign Up',
              'Sign Up Successfully',
              Colors.green,
            );
            Get.offNamed('/login');
          },
        );
      }
    } catch (e) {
      handleAuthError(e, 'Sign Up Failed');
    }
  }

  Future<Map<String, dynamic>> getUser(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot data = await firestore.collection('users').doc(email).get();

      if (data.exists) {
        return data.data() as Map<String, dynamic>;
      } else {
        log('Document does not exist');
        return {};
      }
    } catch (e) {
      log('Error fetching user data: $e');
      return {};
    }
  }


  RxMap userDetail = {}.obs;

  /// Handles user sign-in.
  Future<void> signIn(String email, String pass) async {
    try {
      User? user = await FirebaseAuthServices.authServices.signIn(email, pass);
      if (user != null) {
        userDetail.value = await getUser(email);

        print("printing get user method outcome");
        print(userDetail['name']+"---------------------");
        print(userDetail['email']+"--------------------");
        print(userDetail['mobile']+"-------------------");


        Get.offNamed('/home');
      } else {
        showSnackbar(
          'Login Failed',
          'Incorrect email or password.',
          Colors.red,
        );
      }
    } catch (e) {
      handleAuthError(e, 'Login Failed');
    }
  }

  /// Handles user logout.
  void logOut() {
    FirebaseAuthServices.authServices.sign_Out();
    GoogleLoginServices.googleLoginServices.logOut();
  }

  /// Shows a custom Snackbar with the provided message and color.
  void showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

  /// Handles and logs authentication errors.
  void handleAuthError(dynamic e, String title) {
    log(e.toString());
    showSnackbar(title, e.toString(), Colors.red);
  }
}
