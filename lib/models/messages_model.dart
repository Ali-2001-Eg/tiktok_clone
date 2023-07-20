import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  String name;
  String profilePhotoUrl;
  String uid;

  MessagesModel({
    required this.name,
    required this.uid,
    required this.profilePhotoUrl,
  });
  Map<String, dynamic> toJson() =>
      {'name': name, 'uid': uid, 'profilePhoto': profilePhotoUrl};
  factory MessagesModel.fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return MessagesModel(
      name: snapshot['name'],
      uid: snapshot['uid'],
      profilePhotoUrl: snapshot['profilePhoto'],
    );
  }
}

class ChatModel {
  String message;
  String sender;
  String time;

  ChatModel({
    required this.message,
    required this.sender,
    required this.time,
  });
  factory ChatModel.fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return ChatModel(
      message: snapShot['message'],
      sender: snapShot['sender'],
      time: snapShot['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "sender": sender,
      "time": time,
    };
  }
}
