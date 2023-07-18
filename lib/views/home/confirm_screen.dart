import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/upload_video_controller.dart';
import 'package:tiktok_clone/shared/widgets/custom_indicator.dart';
import 'package:tiktok_clone/shared/widgets/custom_text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmAddVideoScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmAddVideoScreen(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  @override
  State<ConfirmAddVideoScreen> createState() => _ConfirmAddVideoScreenState();
}

class _ConfirmAddVideoScreenState extends State<ConfirmAddVideoScreen> {
  final TextEditingController _musicController = TextEditingController();

  final TextEditingController _captionController = TextEditingController();

  final UploadVideoController _uploadVideoController = Get.put(UploadVideoController());


  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoFile.path));
    _controller
      ..initialize()
      ..play()
      ..setVolume(1)
      ..setLooping(true);
  }
@override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print(_uploadVideoController.isLoading);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: Get.width,
              height: Get.height / 1.5,
              child: VideoPlayer(_controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Get.width - 20,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextInputField(
                        controller: _musicController,
                        icon: Icons.music_note_outlined,
                        labelText: 'Music'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width - 20,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextInputField(
                        controller: _captionController,
                        icon: Icons.closed_caption,
                        labelText: 'Caption'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GetBuilder<UploadVideoController>(
                      builder: (_) => _uploadVideoController.isLoading
                          ? const CustomIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                _uploadVideoController.uploadVideo(
                                    _musicController.text,
                                    _captionController.text,
                                    widget.videoFile).then((value) => _controller.dispose());
                              },
                              child: const Text(
                                'Share',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
