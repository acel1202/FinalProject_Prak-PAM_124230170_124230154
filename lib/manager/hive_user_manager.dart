import 'package:hive/hive.dart';
import '../db/user_model.dart';

class HiveUserManager {
  static const String usersBoxName = 'users_box';

  static Future<Box<AppUser>> _openBox() async {
    if (Hive.isBoxOpen(usersBoxName)) {
      return Hive.box<AppUser>(usersBoxName);
    }
    return await Hive.openBox<AppUser>(usersBoxName);
  }

  static Future<void> addUser(AppUser user) async {
    final box = await _openBox();
    await box.put(user.username, user);
  }

  static Future<AppUser?> getUserByUsername(String username) async {
    final box = await _openBox();
    return box.get(username);
  }

  static Future<bool> usernameExists(String username) async {
    final box = await _openBox();
    return box.containsKey(username);
  }
}
