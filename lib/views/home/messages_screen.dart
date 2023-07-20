import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/explore_controller.dart';
import 'package:tiktok_clone/controllers/messages_controller.dart';
import 'package:tiktok_clone/models/messages_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/shared/widgets/custom_indicator.dart';
import 'package:tiktok_clone/views/home/chat_screen.dart';
import 'package:tiktok_clone/views/home/explore_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MessagesController controller = Get.put(MessagesController());
    // print(controller.friendsList.map((e) => e.uid));
    print(controller.chatList);
    // print(authController.getDisplayName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
              onPressed: () {
                TextEditingController searchController =
                    TextEditingController();
                Get.defaultDialog(
                    title: 'Search for a user',
                    content: TextFormField(
                      decoration: const InputDecoration(
                          filled: false,
                          hintText: 'Username',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey)),
                      onChanged: (value) => Get.find<ExploreController>()
                          .searchUser(searchController.text),
                    ),
                    barrierDismissible: false,
                    cancel: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel')),
                    confirm: TextButton(
                        onPressed: () {
                          Get.off(() => ExploreScreen(
                                searchController: searchController,
                              ));
                        },
                        child: const Text('Explore')));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Obx(() {
        return !controller.friendsList.isNotEmpty
            ? controller.isLoading
                ? const CustomIndicator()
                : const Center(
                    child: Text(
                      'You are not Following anyone to send or get messages!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
            : ListView.builder(
                itemCount: controller.friendsList.length,
                itemBuilder: (context, index) {

                  final members = controller.friendsList[index];
                  return InkWell(
                      onTap: () {
                        controller.getAllMessages(auth.currentUser!.uid,members.uid);
                        Get.to(() => ChatScreen(username: members.name,uid: members.uid,));
                      },
                      child: _buildChatTile(members));
                },
              );
      }),
    );
  }

  Widget _buildChatTile(MessagesModel members) {
    var controller = Get.find<MessagesController>();
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0)
            .add(const EdgeInsets.symmetric(vertical: 10)),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  CachedNetworkImageProvider(members.profilePhotoUrl),
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(members.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                Text(
                    controller.chatList.isNotEmpty
                        ? controller.chatList.last.message
                        : 'Type your first message',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              ],
            )
          ],
        ),
      );
    });
  }
}
