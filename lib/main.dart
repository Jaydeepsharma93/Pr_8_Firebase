import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pr_8_firebase/components/usercheck.dart';
import 'package:pr_8_firebase/views/loginscreen.dart';
import 'package:pr_8_firebase/views/signupScreen.dart';
import 'package:pr_8_firebase/views/userscreen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // Example size
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'snap',
      getPages: [
        GetPage(
          name: '/',
          page: () => AuthGate(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/signup',
          page: () => SignupScreen(),
        ),
        GetPage(
          name: '/user',
          page: () => UserScreen(),
        ),
      ],
    );
  }
}
