import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tiktok_clone/shared/storage/storage.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/views/auth/login_screen.dart';
import 'package:tiktok_clone/views/auth/signup_screen.dart';
import 'package:tiktok_clone/views/home/home_screen.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tiktok',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      home:
      Storage.getUserLoggedIn ? const HomeScreen() : LoginScreen()
      ,
    );
  }
}
