import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = ''.obs;

  bool isFollowing = false;

  bool isLoading = false;

  updateUserUid(String uid) async {
    _uid.value = uid;
    await getProfileData;
  }

  Future<void> get getProfileData async {
    isLoading = true;
    update();
    List<String> thumbnail = [];
    var myVideos = await fireStore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnail.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    // print(name);
    String profilePhoto = userData['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    //add likes and followers and following to video collection
    for (QueryDocumentSnapshot item in myVideos.docs) {
      likes += ((item.data() as Map<String, dynamic>)['likes'] as List).length;
    }
    QuerySnapshot<Map<String, dynamic>> followersDoc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    QuerySnapshot<Map<String, dynamic>> followingDoc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followersDoc.docs.length;
    following = followingDoc.docs.length;
    //check if the user already follows other users
    fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });
    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnail': thumbnail
    };
    isLoading = false;

    update();
  }

  Future<void> followUser() async {
    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String email = userData['email'];
    String profilePhoto = userData['profilePhoto'];

    var doc = await fireStore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(auth.currentUser!.uid)
        .get();
    UserModel model = UserModel(
      name: name,
      email: email,
      uid: _uid.value,
      profilePhoto: profilePhoto,
    );
    if (!doc.exists) {
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('followers')
          .doc(_uid.value)
          .set(model.toJson());
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('following')
          .doc(_uid.value)
          .set(model.toJson());
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await fireStore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(auth.currentUser!.uid)
          .delete();
      await fireStore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
