import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pr_8_firebase/components/authcontroler.dart';

AuthController authController = Get.put(AuthController());

class GoogleLoginServices {
  static GoogleLoginServices googleLoginServices = GoogleLoginServices._();
  GoogleLoginServices._();


  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('User canceled the sign-in process.');
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save user information to Firestore
        await firestore.collection('users').doc(user.email).set({
          'name': user.displayName,
          'email': user.email,
          'mobile': user.phoneNumber,
        });

        authController.userDetail.value = await authController.getUser(user.email!);

        print("printing get user method outcome");
        print(authController.userDetail['name']+"---------------------");
        print(authController.userDetail['email']+"--------------------");
        print(authController.userDetail['mobile']+"-------------------");

      }
    } catch (e) {
      print(e.toString());
    }
  }

  User? currentUser() {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      print(user.email);
      print(user.displayName);
      print(user.phoneNumber);
      print(user.photoURL);
    }
    return user;
  }

  void logOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
