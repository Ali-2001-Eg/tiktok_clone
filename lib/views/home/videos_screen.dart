import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/comments_controller.dart';
import 'package:tiktok_clone/controllers/display_videos_controller.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/shared/widgets/circle_animation_widget.dart';
import 'package:tiktok_clone/shared/widgets/custom_indicator.dart';
import 'package:tiktok_clone/shared/widgets/custom_video_player.dart';

import '../../shared/widgets/custom_snackbar.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
  final DisplayVideosController controller = Get.put(DisplayVideosController());
    return Scaffold(
      body: Obx(() => PageView.builder(
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.videoList.length,
            itemBuilder: (context, index) {
              var data = controller.videoList[index];
              return Stack(
                children: [
                  GestureDetector(
                      onDoubleTap: () => controller.likeVideos(data.id),
                      child: CustomVideoPlayer(videoUrl: data.url)),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //footer
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data.username,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data.caption,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.music_note_outlined,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  data.musicName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                      //right actions
                      Container(
                        margin: EdgeInsets.only(top: Get.size.height / 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //profile pic
                            _buildProfilePhoto(data.profilePhoto),
                            //likes
                            Column(children: [
                              GetBuilder<DisplayVideosController>(
                                  builder: (_) {
                                return InkWell(
                                  onTap: () => controller.likeVideos(data.id),
                                  child: controller.isLoading
                                      ? const CustomIndicator()
                                      : Icon(
                                          Icons.favorite,
                                          size: 40,
                                          color: data.likes.contains(
                                                  auth.currentUser!.uid)
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                );
                              }),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                data.likes.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ]),
                            //comments
                            Column(children: [
                              InkWell(
                                onTap: () {
                                  Get.lazyPut(() => CommentsController());
                                  _showCommentsBottomSheet(context, data);
                                },
                                child: const Icon(
                                  Icons.comment,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                data.commentCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ]),
                            //share
                            Column(children: [
                              InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.replay,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                data.shareCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ]),
                            //music
                            CircleAnimationWidget(
                                child: _buildMusicAlbum(data.profilePhoto)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }

  SizedBox _buildProfilePhoto(String profilePhotoUrl) => SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          children: [
            Positioned(
                left: 5,
                child: Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      image: NetworkImage(profilePhotoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
          ],
        ),
      );
  SizedBox _buildMusicAlbum(String profilePhoto) => SizedBox(
        width: 60,
        height: 60,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [Colors.grey, Colors.white]),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      );

  void _showCommentsBottomSheet(BuildContext context, VideoModel video) {
    final TextEditingController commentController = TextEditingController();
    Get.bottomSheet(
      GetBuilder<CommentsController>(builder: (controller) {
        controller.updateId(video.id);
        return Container(
          padding: const EdgeInsets.only(top: 4),
          height: Get.height * 1.7,
          decoration: const BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10), left: Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Divider(color: Colors.grey[600], thickness: 1, height: 2),
              !controller.commentsList.isNotEmpty
                  ? const Expanded(
                      child: Center(
                          child: Text(
                      'Be the first person and comment for this reel....',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    )))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: controller.commentsList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final comment = controller.commentsList[index];
                          return _buildCommentTile(comment);
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                    title: TextFormField(
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      controller: commentController,
                      decoration: InputDecoration(
                          hintText: 'Comment',
                          hintStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          )),
                    ),
                    trailing: InkWell(
                        onTap: () {
                          if (commentController.text.isNotEmpty) {
                            controller.addComment(commentController.text);
                            commentController.text = '';
                          } else {
                            customSnackBar('Error', 'Enter a comment please');
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.send,
                              color: Colors.red,
                              size: 25,
                            )))),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return GetBuilder<CommentsController>(builder: (commentController) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: NetworkImage(comment.profilePhoto),
          radius: 25,
        ),
        title: Row(
          children: [
            Text(
              comment.username,
              style: const TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                comment.comment,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                comment.datePublished.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
            Text(
              '${comment.likes.length} likes',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            commentController.likeComment(comment.id);
          },
          child: Icon(
            comment.likes.contains(auth.currentUser!.uid)
                ? Icons.favorite
                : Icons.favorite_outline,
            color: comment.likes.contains(auth.currentUser!.uid)
                ? Colors.red
                : Colors.white,
          ),
        ),
      );
    });
  }
}
