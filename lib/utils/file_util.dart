import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/urls.dart';
import 'package:flutter_chat_craft/utils/http_util.dart';
import 'package:get/get.dart';
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

  static Future<bool> downloadEmoji() async {
    // Set initial progress to 0%
    Rx<double> progress = 0.0.obs;

    try {
      String url = Urls.downloadEmojiZip;
      String cachePath = await getEmojiCachePath();

      Get.dialog(
        Obx(
          () => AlertDialog(
            title: const Text("Downloading Emoji"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Download progress: ${progress.toStringAsFixed(2)}%"),
                LinearProgressIndicator(value: progress / 100),
              ],
            ),
          ),
        ),
      );
      await HttpUtil.download(url, cachePath: cachePath,
          onProgress: (count, total) {
        // Update the progress and redraw the dialog
        progress.value = count / total * 100;
        print("Download progress: ${progress.toStringAsFixed(2)}%");
      });

      // Close the dialog when download completes
      Get.back(); // close the download progress dialog
      print("Download completed!");
      return true;
    } catch (e) {
      // Handle errors and close the dialog
      Get.back(result: false); // close the download progress dialog
      print("Error occurred: $e");
      return false;
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
