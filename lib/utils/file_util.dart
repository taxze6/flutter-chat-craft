import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_chat_craft/common/urls.dart';
import 'package:flutter_chat_craft/utils/http_util.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  ///Compare file sizes
  static Future<bool> isFileCompleteBySize(
      String filePath, int expectedSize) async {
    try {
      File file = File(filePath);
      int fileSize = await file.length();
      if (fileSize == expectedSize) {
        print('File integrity');
        return true;
      } else {
        print('Incomplete file');
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isFileCompleteByHash(
      String filePath, String expectedHash) async {
    File file = File(filePath);
    List<int> fileBytes = await file.readAsBytes();

    // Calculates the hash value of the file
    String fileHash = md5.convert(fileBytes).toString();

    if (fileHash == expectedHash) {
      print('File integrity');
      return true;
    } else {
      print('Incomplete file');
      return false;
    }
  }

  /// Get the application sandbox directory path.
  static Future<String> getApplicationSupportDirectoryPath() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  static Future<void> downloadEmoji() async {
    try {
      String url = Urls.downloadEmojiZip;
      String cachePath = await getEmojiCachePath();
      print(cachePath);
      await HttpUtil.download(
        url,
        cachePath: cachePath,
        onProgress: (count, total) {
          double progress = count / total * 100;
          print("Download progress: ${progress.toStringAsFixed(2)}%");
        },
      );
      print("Download completed!");
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  static Future<String> getEmojiCachePath() async {
    try {
      final externalStorageDirectory = await getExternalStorageDirectory();
      String emojiCachePath =
          "${externalStorageDirectory?.path}/chat-craft/emoji_icon_data.zip";
      return emojiCachePath;
    } catch (e) {
      print("Error setting emoji cache path: $e");
      return "";
    }
  }
}
