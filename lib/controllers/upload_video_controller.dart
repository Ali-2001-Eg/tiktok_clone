import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/shared/widgets/custom_snackbar.dart';
import 'package:tiktok_clone/views/home/add_video_screen.dart';

class UploadVideoController extends GetxController {
  bool isLoading = false;

  Future<void> uploadVideo(
      String musicName, String caption, File videoPath) async {
    try {
      isLoading= true;
      update();
      //first we will get all users
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection('users').doc(uid).get();
      QuerySnapshot allDocs = await fireStore.collection('videos').get();
      //length will be id for all new videos
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage('Video $len', videoPath);
      //to upload images thumbnails for each video
      final thumbnail =
          await _uploadImageToStorage('Thumbnail $len', videoPath);
      //then we can push to database
      VideoModel model = VideoModel(
        id: "Video $len",
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        likes: [],
        commentCount: 0,
        shareCount: 0,
        thumbnail: thumbnail,
        url: videoUrl,
        caption: caption,
        musicName: musicName,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
      );
      await fireStore
          .collection('videos')
          .doc(model.id)
          .set(model.toSnapshots())
          ;

      Get.off(()=> const AddVideoScreen());
      customSnackBar('Video uploaded', 'Video uploaded Successfully');
    } catch (e) {
      print(e.toString());
      customSnackBar('Uploading Video', e.toString());
    }
    isLoading = false;
    update();
  }

  Future<String> _uploadVideoToStorage(String id, File videoPath) async {
    Reference ref = storage.ref('videos').child(id);
    //videos must be compressed to be pushed to storage to decrease videos' sizes
    UploadTask task = ref.putFile((videoPath));
    TaskSnapshot snap = await task;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }



  Future<String> _uploadImageToStorage(String id, File videoPath) async {
    Reference ref = storage.ref('thumbnails').child(id);
    UploadTask task = ref.putFile(videoPath);
    TaskSnapshot snap = await task;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }


}
