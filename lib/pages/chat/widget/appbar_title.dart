import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../res/strings.dart';

class AppBarTitle extends StatefulWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Timer _timer;
  bool showTextOrIcon = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        if (_controller.isCompleted) {
          _controller
              .reverse()
              .then((value) => showTextOrIcon = !showTextOrIcon);
        } else {
          _controller.forward();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: showTextOrIcon
          ? Text(
              StrRes.chatCraft,
            )
          : SvgPicture.asset(
              ImagesRes.appIcon,
              width: 36.w,
              height: 36.w,
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
