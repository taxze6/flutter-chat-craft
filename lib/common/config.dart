import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/sp/sp_util.dart';

class Config {
  static late String cachePath;
  static const UI_W = 375.0;
  static const UI_H = 812.0;

  static const ip = "192.168.31.135";
  static const apiUrl = "http://$ip:8889/v1";

  static Future init(Function() runApp) async {
    // Initialize a WidgetsBinding to ensure that the Flutter framework has been initialized
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    runApp();
    // Set screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Transparent status bar (Android).
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
  }
}
