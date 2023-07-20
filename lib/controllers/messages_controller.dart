import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tiktok_clone/models/messages_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';

class MessagesController extends GetxController {
  final String uid = auth.currentUser!.uid;
  final Rx<List<MessagesModel>> _friendsList = Rx<List<MessagesModel>>([]);
  List<MessagesModel> get friendsList => _friendsList.value;
  final Rx<List<ChatModel>> _chatList = Rx<List<ChatModel>>([]);
  List<ChatModel> get chatList => _chatList.value;
  bool isLoading = false;
  @override
  onInit() {

    _getFollowersAndFollowingList();
    super.onInit();
  }

  Future<void> _getFollowersAndFollowingList() async {
    isLoading = true;
    update();
    _friendsList.bindStream(fireStore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .snapshots()
        .map((query) {
      List<MessagesModel> followers = [];
      for (var element in query.docs) {
        followers.add(MessagesModel.fromJson(element));
      }
      return followers;
    }));
    _friendsList.bindStream(fireStore
        .collection('users')
        .doc(uid)
        .collection('following')
        .snapshots()
        .map((query) {
      List<MessagesModel> following = [];
      for (var element in query.docs) {
        following.add(MessagesModel.fromJson(element));
      }
      return following;
    }));
    isLoading = false;
    update();
  }

  Future<void> sendMessage(String messageText , String receiverUid, String senderUid) async {
    DocumentSnapshot userDoc =
        await fireStore.collection('users').doc(uid).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    ChatModel message = ChatModel(
        message: messageText, sender: name, time: DateTime.now().toString());
    //doc name will be  _receiver
    fireStore
        .collection('conversations')
        .doc('$senderUid _ $receiverUid')
        .collection('messages')
        .add(message.toJson());
  }

  Future<void> getAllMessages(String senderUid, String receiverUid) async {
    _chatList.bindStream(fireStore
        .collection('conversations')
        .doc('$senderUid _ $receiverUid')
        .collection('messages').orderBy('time',descending: false)
        .snapshots()
        .map((message) {
      List<ChatModel> chats = [];
      for (var element in message.docs) {
        chats.add(ChatModel.fromSnap(element));
      }
      return chats;
    }));
  }

  ChatModel get getLastMessage => _chatList.value.last;
}
