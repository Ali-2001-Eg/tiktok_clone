import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/shared/widgets/custom_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return GetBuilder<ProfileController>(
        // init: ProfileController(),
        builder: (controller) {
      controller.updateUserUid(uid);
      if (controller.user.isEmpty) {
        return const CustomIndicator();
      } else {
        // print(controller.user['profilePhoto']);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: const Icon(Icons.person_add_alt_1_outlined),
              actions: const [
                Icon(Icons.more_horiz_outlined),
              ],
              centerTitle: true,
              title: Text(
                controller.user['name'],
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:controller.user['profilePhoto'],
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            placeholder: (context, url) => const CustomIndicator(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              controller.user['following'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Following',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            Text(
                              controller.user['followers'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Followers',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            Text(
                              controller.user['likes'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Likes',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GetBuilder<AuthController>(builder: (_) {
                      // print(_.isLoading);
                      return InkWell(
                        onTap: () => uid == auth.currentUser!.uid
                            ? Get.defaultDialog(
                                barrierDismissible: false,
                                title: 'Sign Out!',
                                textCancel: 'Cancel',
                                textConfirm: 'Yes',
                                content: const Text(
                                    'Are you sure you want to sign out ?!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                                onCancel: () => Get.back(),
                                onConfirm: () =>
                                    Get.find<AuthController>().signOut(),
                              )
                            : controller.followUser(),
                        child: Container(
                          width: 140,
                          height: 47,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              uid == auth.currentUser!.uid
                                  ? 'Sign Out'
                                  : controller.user['isFollowing']
                                      ? 'Unfollow'
                                      : 'Follow',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),


              ],
            ));
      }
    });
  }
}
