import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_8_firebase/views/loginscreen.dart';
import 'package:pr_8_firebase/views/userscreen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if our user is logged in
          if (snapshot.hasData) {
            return  UserScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}