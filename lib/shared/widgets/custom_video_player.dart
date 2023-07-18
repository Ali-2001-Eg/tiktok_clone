import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool isPlaying = true;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _controller.play();
        _controller.setVolume(1);
        _controller.setLooping(true);
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = Get.size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: InkWell(
        onTap: () {
          _toggleVideoState();
        },
        child: VideoPlayer(_controller),
      ),
    );
  }

  void _toggleVideoState() {
    setState(() {
      isPlaying = !isPlaying;
    });
    isPlaying ? _controller.play() : _controller.pause();
  }
}
