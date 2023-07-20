import 'package:flutter/material.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/views/home/add_video_screen.dart';
import 'package:tiktok_clone/views/home/explore_screen.dart';
import 'package:tiktok_clone/views/home/messages_screen.dart';
import 'package:tiktok_clone/views/home/profile_screen.dart';
import 'package:tiktok_clone/views/home/videos_screen.dart';

import '../../shared/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const VideosScreen(),
    ExploreScreen(),
    const AddVideoScreen(),
    const MessagesScreen(),
    ProfileScreen(uid: auth.currentUser!.uid),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          currentIndex: _pageIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                label: 'Explore'),
            BottomNavigationBarItem(icon: CustomIcon(), label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                  size: 30,
                ),
                label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                label: 'Profile'),
          ],
        ),
        body: Center(child: _pages[_pageIndex]),
      ),
    );
  }
}
