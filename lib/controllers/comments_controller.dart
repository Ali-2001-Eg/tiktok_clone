import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/comment_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';
import 'package:tiktok_clone/shared/widgets/custom_snackbar.dart';

class CommentsController extends GetxController {
  bool isLoading = false;
  final Rx<List<CommentModel>> _commentList = Rx<List<CommentModel>>([]);
  String _postId = '';
  List<CommentModel> get commentsList => _commentList.value;
  Future<void> addComment(String comment) async {
    isLoading = true;
    update();
    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(auth.currentUser!.uid).get();
    var allDocs = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .get();
    int len = allDocs.docs.length;
    CommentModel model = CommentModel(
      username: (userDoc.data()! as dynamic)['name'],
      comment: comment.trim(),
      datePublished: DateTime.now(),
      likes: [],
      profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
      uid: auth.currentUser!.uid,
      id: 'Comment $len',
    );

    await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(model.id)
        .set(model.toJson())
        .then((value) => print('success'))
        .catchError((e) {
      print(e.toString());
      customSnackBar('Error', e.toString());
    });
    DocumentSnapshot doc =
        await fireStore.collection('videos').doc(_postId).get();
    await fireStore.collection('videos').doc(_postId).update({
      'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
    });
    isLoading = false;
    update();
  }

  Future<void> get _getAllComments async {
     _commentList.bindStream(fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((query) {
      List<CommentModel> comments = [];
      for (var element in query.docs) {
        comments.add(CommentModel.fromSnapShot(element));
      }
      return comments;
    }));

  }

  Future<void> updateId(String id) async {
    isLoading = true;
    update();
    _postId = id;
    // print(_postId);
    await _getAllComments;
    isLoading = false;
    update();
  }

  Future<void> likeComment(String id) async {
    var uid = auth.currentUser!.uid;
    DocumentSnapshot doc = await fireStore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await fireStore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
