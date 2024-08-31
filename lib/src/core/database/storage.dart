import 'package:hive_flutter/hive_flutter.dart';

abstract class StorageString {
  static const String mainAppBoxName = 'ms-app';
  static const String accessToken = 'access-token';
  static const String userId = 'user-id';
}

class Storage {
  Storage._();
  static Storage instance = Storage._();

  Future<void> setToken(String token) async {
    final box = Hive.box(StorageString.mainAppBoxName);
    await box.put(StorageString.accessToken, token);
  }

  String? getToken() {
    final box = Hive.box(StorageString.mainAppBoxName);
    return box.get(StorageString.accessToken, defaultValue: null);
  }

  Future<void> setId(String id) async {
    final box = Hive.box(StorageString.mainAppBoxName);
    await box.put(StorageString.userId, id);
  }

  String? getId() {
    final box = Hive.box(StorageString.mainAppBoxName);
    return box.get(StorageString.userId, defaultValue: null);
  }

  Future<void> clear() async {
    final box = Hive.box(StorageString.mainAppBoxName);
    await box.clear();
  }
}
