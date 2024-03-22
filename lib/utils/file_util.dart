import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final externalStorageDirectory = await getApplicationDocumentsDirectory();
      String emojiCachePath =
          "${externalStorageDirectory.path}/chat-craft/emoji_icon_data.zip";
      return emojiCachePath;
    } catch (e) {
      print("Error setting emoji cache path: $e");
      return "";
    }
  }

  static Future<void> extractZipFile(String filePath) async {
    // Set initial progress to 0%
    Rx<int> progress = 0.obs;
    try {
      final zipFile = File(filePath);
      final bytes = zipFile.readAsBytesSync();
      final dir = await getApplicationDocumentsDirectory();
      Directory destinationDir = Directory('${dir.path}/chat-craft');
      if (await destinationDir.exists()) {
        final deletedDir = await destinationDir.delete(recursive: true);
        if (deletedDir is Directory) {
          print('Directory deletion succeeded！');
        } else {
          print('Directory deletion failed！');
        }
      }
      await destinationDir.create(recursive: true);
      final archive = ZipDecoder().decodeBytes(bytes);
      int totalFiles = archive.numberOfFiles();
      print('totalFiles ==== $totalFiles');

      Get.dialog(
        Obx(
          () => AlertDialog(
            title: const Text("Unpacker Emoji Zip"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Number of decompressed files: $progress / $totalFiles"),
                LinearProgressIndicator(
                  value: progress / totalFiles,
                ),
              ],
            ),
          ),
        ),
      );
      int extractedFiles = 0;
      // Get current time.
      String startTime = getTime;
      print('Start Time ==== $startTime');
      for (final file in archive) {
        final filePath = '${destinationDir.path}/${file.name}';
        print('filePath===$filePath');
        if (file.isFile) {
          final data = file.content as List<int>;
          final decodedData = utf8.decode(data, allowMalformed: true);
          final outFile = File(filePath);
          await outFile.create(recursive: true);
          await outFile.writeAsString(decodedData, flush: true);
          // print(file.name);
        } else {
          await Directory(filePath).create(recursive: true);
        }
        extractedFiles++;
        progress.value = extractedFiles ~/ totalFiles;
        // setState(() {
        //   _extractProgress = extractedFiles / totalFiles;
        //   // print(_extractProgress);
        // });
      }
      String endTime = getTime;
      print('End Time ==== $endTime');
    } catch (e) {
      print('Error while extracting the zip file: $e');
    }
  }

  static String get getTime {
    return "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().second}:${DateTime.now().millisecond}:${DateTime.now().microsecond}";
  }
}
