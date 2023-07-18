import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/views/home/confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showOptionsDialog(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: buttonColor),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<SimpleDialog?> showOptionsDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: <SimpleDialogOption>[
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.gallery, context),
              child: Row(
                children: const [
                  Icon(Icons.image),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Gallery',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.camera, context),
              child: Row(
                children: const [
                  Icon(Icons.camera_alt),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Camera',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: Row(
                children: const [
                  Icon(Icons.cancel),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Future<void> pickVideo(ImageSource src, BuildContext context) async {
     video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Get.to(() => ConfirmAddVideoScreen(
          videoFile: File(video.path), videoPath: video.path));
    }
  }
}
var video;