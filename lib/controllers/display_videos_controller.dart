import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';

class DisplayVideosController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);
  List<VideoModel> get videoList => _videoList.value;
  bool isLoading = false;

  @override
  void onInit() {
    _videoList
        .bindStream(fireStore.collection('videos').snapshots().map((query) {
      List<VideoModel> videos = [];
      for (var element in query.docs) {
        videos.add(VideoModel.fromSnapshots(element));
      }
      return videos;
    }));

    super.onInit();
  }

  //like videos

  likeVideos(String id) async {
    isLoading= true;
    update();
    DocumentSnapshot snap = await fireStore.collection('videos').doc(id).get();
    var uid = auth.currentUser!.uid;
    if ((snap.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });

    } else {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });

    }
    isLoading = false;
    update();

  }
}
