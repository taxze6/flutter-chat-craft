import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/mine/mine_logic.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key, required this.controller}) : super(key: key);
  final MineLogic controller;

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with SingleTickerProviderStateMixin {
  late MineLogic mineLogic;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    mineLogic = widget.controller;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();
  }

  void closePage() {
    _controller.reverse().then((_) {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: closePage,
      child: Material(
        color: const Color(0x00000000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: 1.sw,
                height: 0.9.sh,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(42.w),
                    topRight: Radius.circular(42.w),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Column(
                      children: [
                        closeButton(),
                        userInfoView(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget closeButton() {
    return Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: closePage,
          icon: const Icon(Icons.close),
          iconSize: 26.w,
        ));
  }

  Widget userInfoView() {
    return Column(
      children: [
        AvatarWidget(
          imageUrl: mineLogic.userInfo.avatar,
          imageSize: Size(88.w, 88.w),
          radius: 26.w,
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.w),
          child: Text(
            mineLogic.userInfo.userName,
            style: TextStyle(
              fontSize: 28.sp,
            ),
          ),
        ),
        Text(
          mineLogic.userInfo.motto,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
