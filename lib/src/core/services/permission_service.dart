import 'dart:io';

import 'package:chat/src/core/services/device_info_service.dart';
import 'package:chat/src/core/widgets/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    Permission permission = Permission.camera;
    bool isGranted = await _checkPermmisionIsGranted(permission);
    if (isGranted) return true;
    if (!context.mounted) return false;
    final status = await requestPermission(
      context: context,
      permission: permission,
      title: 'Camera Permission Denied',
      message:
          'The app needs access to your camera to take photos and videos. ',
    );
    return status;
  }

  static Future<bool> requestGalleryPermission(BuildContext context) async {
    late Permission permission;
    if (Platform.isAndroid) {
      int sdk = await DeviceInfoService.getSdk();
      if (sdk <= 32) {
        permission = Permission.storage;
      } else {
        permission = Permission.photos;
      }
    } else {
      permission = Permission.photos;
    }
    bool isGranted = await _checkPermmisionIsGranted(permission);
    if (isGranted) return true;
    if (!context.mounted) return false;
    final status = await requestPermission(
      context: context,
      permission: permission,
      title: 'Gallery Permission Denied',
      message:
          'The app needs access to your gallery to select and upload photos and videos.',
    );
    return status;
  }

  static Future<bool> requestPermission({
    required BuildContext context,
    required Permission permission,
    String title = 'Permission Denied',
    String message =
        'The app needs access to your device features to function properly. Please enable the required permissions in the app settings.',
  }) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) return true;
    if (status == PermissionStatus.denied) {
      return false;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      if (!context.mounted) return false;
      _showPermissionDeniedBottomSheet(
        context,
        title: title,
        message: message,
      );
    }
    return false;
  }

  static Future<bool> _checkPermmisionIsGranted(Permission permission) async {
    bool isGranted = await permission.isGranted;
    return isGranted;
  }

  static Future<void> _showPermissionDeniedBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return PermissionDialog(
          title: title,
          message: message,
        );
      },
    );
  }
}
