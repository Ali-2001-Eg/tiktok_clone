import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/explore_controller.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/views/home/profile_screen.dart';
import 'package:tiktok_clone/views/home/searched_profile_screen.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ExploreController());
    final controller = Get.find<ExploreController>();
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextFormField(
              decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.white)),
              onChanged: (value) => Get.find<ExploreController>()
                  .searchUser(searchController.text.trim()),
            ),
          ),
          body: controller.searchedUser.isEmpty
              ? const Center(child: Text('Search for Users'))
              : ListView.builder(
                  itemCount: controller.searchedUser.length,
                  itemBuilder: (context, index) {
                    UserModel user = controller.searchedUser[index];
                    return ListTile(
                      onTap: () =>
                          Get.to(() => SearchedProfileScreen(uid: user.uid)),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePhoto),
                      ),
                      title: Text(
                        user.name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  },
                ),
        ));
  }
}
