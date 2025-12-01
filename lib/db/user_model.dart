import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1) // pastikan tidak bentrok dengan typeId lain di projectmu
class AppUser {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  AppUser({
    required this.username,
    required this.email,
    required this.password,
  });
}
