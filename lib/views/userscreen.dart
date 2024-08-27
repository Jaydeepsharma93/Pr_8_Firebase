import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pr_8_firebase/components/authcontroler.dart';
import 'package:pr_8_firebase/components/authservice.dart';
import 'package:pr_8_firebase/components/chatservice.dart';
import 'package:pr_8_firebase/views/chatview.dart';
import 'package:pr_8_firebase/views/loginscreen.dart';



class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  final ChatService _chatService = ChatService();
  final FirebaseAuthServices _authService = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.person,
            size: 25.sp,
          ),
        ),
        title: Text(
          "Chat",
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 22.h,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_add,
              size: 25.sp,
            ),
          ),
          IconButton(
            onPressed: () {
              authController.logOut();
              Fluttertoast.showToast(
                msg: "Logged out successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.sp,
              );
              Get.off(() => LoginScreen());
            },
            icon: Icon(Icons.logout, size: 25.sp),
          ),
        ],
        elevation: 20,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          // Error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // No data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          }
          // Return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // Display all users except the current user
    if (userData['email'] != _authService.getCurrentUser()?.email) {
      return Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 28.sp,
              backgroundImage: AssetImage('aseets/img/us.jpg'),
            ),
            title: Text(
              userData['name'] ?? 'No name',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            subtitle: Text("Tap to chat"),
            trailing: Icon(
              Icons.photo_camera_outlined,
              size: 25.sp,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverEmail: userData['email'],
                  name: userData['name'],
                ),
              ));
            },
          ),
          Divider(thickness: 1.5,)
        ],
      );
    } else {
      return SizedBox
          .shrink(); // Use SizedBox.shrink() instead of Container() for empty space
    }
  }
}
