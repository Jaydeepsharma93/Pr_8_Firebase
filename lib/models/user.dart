import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name, phone, email;

  UserModel({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserModel.fromMap(Map m1) {
    return UserModel(
      name: m1['name'],
      phone: m1['phone'],
      email: m1['email'],
    );
  }

  Map<String, String?> toMap(UserModel user) {
    return {
      'name': user.name,
      'phone': user.phone,
      'email': user.email,
    };
  }
}


class Message {
  final String senderID;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
        required this.receiverID,
        required this.message,
        required this.timestamp,
      });

//   convert to a map

  Map<String, dynamic> toMap(){
    return {
      'senderID' : senderID,
      'receiverID' : receiverID,
      'message' : message,
      'timestamp' : timestamp,
    };
  }

}