import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String username;
  final String uid;
  final List likes;
  final int commentCount;
  final int shareCount;
  final String musicName;
  final String caption;
  final String url;
  final String thumbnail;
  final String profilePhoto;

  VideoModel({
    required this.id,
    required this.username,
    required this.uid,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.thumbnail,
    required this.url,
    required this.caption,
    required this.musicName,
    required this.profilePhoto,
  });


  factory VideoModel.fromSnapshots(DocumentSnapshot snapshot) {
    Map<String, dynamic> snapshots = snapshot.data() as Map<String, dynamic>;
    return VideoModel(
      id: snapshots["id"],
      username: snapshots["username"],
      uid: snapshots["uid"],
      likes: snapshots["likes"],
      commentCount: (snapshots["commentCount"]),
      shareCount: (snapshots["shareCount"]),
      musicName: snapshots["musicName"],
      caption: snapshots["caption"],
      url: snapshots["url"],
      thumbnail: snapshots["thumbnail"],
      profilePhoto: snapshots["profilePhoto"],
    );
  }



  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "uid": uid,
      "likes": likes,
      "commentCount": commentCount,
      "shareCount": shareCount,
      "musicName": musicName,
      "caption": caption,
      "url": url,
      "thumbnail": thumbnail,
      "profilePhoto": profilePhoto,
    };
  }

}
