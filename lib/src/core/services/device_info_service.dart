import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static Future<int> getSdk() async {
    if (!Platform.isAndroid) {
      throw Exception('This function is only supported on Android devices.');
    }
    AndroidDeviceInfo androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
    return androidDeviceInfo.version.sdkInt;
  }
}