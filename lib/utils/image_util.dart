import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageUtil {
  static ImageProvider getAssetImage(String name, {ImageFormat format = ImageFormat.png}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name, {ImageFormat format = ImageFormat.png}) {
    return 'assets/images/$name.${format.value}';
  }
}

enum ImageFormat { png, jpg, gif, webp, svg }

extension ImageFormatExtension on ImageFormat {
  String get value => ['png', 'jpg', 'gif', 'webp', 'svg'][index];
}
