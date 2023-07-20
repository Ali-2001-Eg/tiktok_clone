import 'package:get/get.dart';
import 'package:tiktok_clone/models/user_model.dart';
import 'package:tiktok_clone/shared/utils/constants.dart';

class ExploreController extends GetxController {
  final Rx<List<UserModel>> _searchedUser = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUser => _searchedUser.value;

  Future<void> searchUser(String? searchText) async {
    print('Ali');
    _searchedUser.bindStream(fireStore
        .collection('users')
        .where('name',  isGreaterThan: searchText)
        .snapshots()
        .map((query) {
      List<UserModel> user = [];
      for (var element in query.docs) {
        user.add(UserModel.fromSnapshot(element));
      }
      return user;
    }));
  }
}
