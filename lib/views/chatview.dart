import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pr_8_firebase/components/chatservice.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String name;

  const ChatScreen(
      {super.key, required this.receiverEmail, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverEmail, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String senderID = _auth.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call))
        ],
        elevation: 20,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _chatService.getMessage(widget.receiverEmail, senderID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Text('Loading...',
                          style: TextStyle(fontSize: 20.sp)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages.'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data();
                    bool isSentByMe = message['senderID'] == senderID;

                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: isSentByMe
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            message['message'],
                            style: TextStyle(
                                color:
                                    isSentByMe ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            child: SizedBox(
              height: 45.h,
              child: TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.mic),
                  hintText: 'Send a message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r)),
                ),
                onFieldSubmitted: (value) {
                  sendMessage(); // Fixed: Call the method with parentheses
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
