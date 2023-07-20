import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/messages_controller.dart';
import 'package:tiktok_clone/models/messages_model.dart';
import 'package:tiktok_clone/shared/widgets/custom_snackbar.dart';
import 'package:tiktok_clone/shared/widgets/message_tile.dart';

import '../../shared/utils/constants.dart';

class ChatScreen extends StatelessWidget {
  final String username;
  final String uid;
  const ChatScreen({Key? key, required this.username, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final MessagesController controller = Get.find<MessagesController>();
    print(controller.chatList.length);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(username),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
                onTap: () =>
                    controller.getAllMessages(auth.currentUser!.uid, uid),
                child: const Icon(Icons.info)),
          )
        ],
      ),
      body: Obx(() {
        return Stack(children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: controller.chatList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (controller.chatList.isNotEmpty) {
                  int reversedIndex = controller.chatList.length - index - 1;
                  return MessageTile(
                      message: controller.chatList[index].message,
                      sender: controller.chatList[index].sender,
                      sentByMe: index % 2 == 0,
                      time: controller.chatList[index].time);
                } else {
                  return Text('Ali');
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.maxFinite,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white, width: 2)),
              // color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      (messageController.text.isNotEmpty)
                          ? controller
                              .sendMessage(
                                  messageController.text, uid, controller.uid)
                              .then((value) => messageController.text = '')
                          : customSnackBar(
                              'Error', 'Type a Message to be sent');
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]);
      }),
    );
  }
}
