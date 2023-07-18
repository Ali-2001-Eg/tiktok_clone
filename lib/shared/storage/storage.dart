import 'package:get_storage/get_storage.dart';

class Storage {
  static final GetStorage box = GetStorage();

  static bool get getUserLoggedIn {
    return box.read<bool>('isLoggedIn') ?? false;
  }

  static void saveUserInfo(bool isLoggedIn) {
    box.write('isLoggedIn', isLoggedIn);
  }
  static void clear(){
    box.erase();
  }
}
