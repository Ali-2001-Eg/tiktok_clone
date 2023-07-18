import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String profilePhoto;

  UserModel(
      {required this.name,
      required this.email,
      required this.uid,
      required this.profilePhoto});

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> snapshots = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        name: snapshots['name'],
        email: snapshots['email'],
        uid: snapshots['uid'],
        profilePhoto: snapshots['profilePhoto']);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "profilePhoto": profilePhoto,
    };
  }
}
