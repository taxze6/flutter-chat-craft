import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/sp/data_persistence.dart';

class AppController extends GetxController {
  Locale? getLocale() {
    var local = Get.locale;
    var index = DataPersistence.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = const Locale('zh', 'CN');
        break;
      case 2:
        local = const Locale('en', 'US');
        break;
    }
    return local;
  }
}
