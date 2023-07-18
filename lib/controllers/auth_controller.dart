import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/shared/storage/storage.dart';
import 'package:tiktok_clone/shared/widgets/custom_snackbar.dart';
import 'package:tiktok_clone/views/auth/login_screen.dart';
import 'package:tiktok_clone/views/home/home_screen.dart';

import '../shared/utils/constants.dart';

class AuthController extends GetxController {
  bool isLoading = false;

  static AuthController instance = Get.find();
  Future<void> register(
      String username, String email, String password, File? image) async {
    try {
      isLoading = true;
      update();
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //we will save our user to auth and fireStore
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          isLoading = false;
          update();
          return Get.to(() => LoginScreen());
        });
        String downloadUrl = await _uploadToStorage(image);
        UserModel model = UserModel(
            name: username,
            email: email,
            uid: auth.currentUser!.uid,
            profilePhoto: downloadUrl);
        await fireStore.collection('users').doc(model.uid).set(model.toJson());
      } else {
        customSnackBar('Error Creating account', 'Please Enter All Fields');
      }
    } catch (e) {
      customSnackBar('Error Creating account', e.toString());
    }
    isLoading = false;
    update();
  }

  //upload profile image to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref =
        storage.ref().child('ProfilePics').child(auth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //for picking image from gallery
  Rx<File?>? _pickedImage;
  late Rx<User?> _user;
  File? get pickedImage => _pickedImage?.value;

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
    update();
  }

  Future<void> userLogin(String email, String password) async {
    try {
      isLoading = true;
      update();
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Storage.saveUserInfo(true);
          return Get.offAll(() => const HomeScreen());
        });
      } else {
        customSnackBar('Error', 'Invalid username');
      }
    } catch (e) {
      customSnackBar('Invalid', e.toString());
    }
    isLoading = false;
    update();
  }

  Future<void> signOut() async {
    await auth.signOut().then((value) => Storage.clear()).then((value) {
      isLoading = false;
      update();
      return Get.offAll(() => LoginScreen());
    }).catchError((e) {
      print('Error');
      return customSnackBar('Error', e.toString());
    });
  }
}
