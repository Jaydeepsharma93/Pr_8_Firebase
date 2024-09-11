import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pr_8_firebase/components/chatservice.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String name;

  const ChatScreen({super.key, required this.receiverEmail, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _editMessageID = '';
  String _editedMessageContent = '';

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverEmail, _messageController.text);
      _messageController.clear();
    }
  }

  void _showEditMessageDialog(String messageID, String currentMessage) {
    _editMessageID = messageID;
    _editedMessageContent = currentMessage;

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _editController = TextEditingController(text: currentMessage);

        return AlertDialog(
          title: Text("Edit Message"),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(hintText: "Edit your message"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _chatService.editMessage(
                    _getChatRoomID(widget.receiverEmail, _auth.currentUser!.email!),
                    messageID,
                    _editController.text
                );
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showMessageOptions(String messageID, String messageContent) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Message"),
              onTap: () {
                Navigator.pop(context);
                _showEditMessageDialog(messageID, messageContent);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Unsend Message"),
              onTap: () {
                Navigator.pop(context);
                _chatService.unsendMessage(
                    _getChatRoomID(widget.receiverEmail, _auth.currentUser!.email!),
                    messageID
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _getChatRoomID(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    return ids.join('_');
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
                  return Center(child: Text('Loading...', style: TextStyle(fontSize: 20.sp)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages.'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data();
                    String messageID = messages[index].id;
                    bool isSentByMe = message['senderID'] == senderID;

                    return GestureDetector(
                      onLongPress: () {
                        if(isSentByMe){
                          _showMessageOptions(messageID, message['message']);
                        }
                      },
                      child: Align(
                        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: isSentByMe ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              message['message'],
                              style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
                            ),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r)),
                ),
                onFieldSubmitted: (value) {
                  sendMessage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
