import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common/config.dart';
import '../core/app_controller.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key, required this.builder}) : super(key: key);
  final Widget Function(
          Locale? locale, Widget Function(BuildContext context, Widget? child))
      builder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (controller) => ScreenUtilInit(
        designSize: const Size(Config.UI_W, Config.UI_H),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => builder(controller.getLocale(), BotToastInit()),
      ),
    );
  }
}
