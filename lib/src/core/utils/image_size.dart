import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as img;

class ImageSize {
  static Future<Size?> getSize(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image != null && image.width > 0 && image.height > 0) {
        final width = image.width.toDouble();
        final height = image.height.toDouble();
        return Size(width, height);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
