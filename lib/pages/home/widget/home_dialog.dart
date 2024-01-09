import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../res/strings.dart';

class HomeDialog extends StatefulWidget {
  const HomeDialog({
    super.key,
    required this.toAddFriend,
    required this.toAddNewChat,
  });

  final GestureTapCallback toAddFriend;
  final GestureTapCallback toAddNewChat;

  @override
  State<HomeDialog> createState() => _HomeDialogState();
}

class _HomeDialogState extends State<HomeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;

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
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
    _controller.forward();
  }

  void _closeDialogWithAnimation() {
    setState(() {
      _offsetAnimation = Tween<Offset>(
        begin: const Offset(2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ));
    });
    _controller.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    return GestureDetector(
      onTap: () {
        _closeDialogWithAnimation();
      },
      child: Material(
        color: const Color(0x00000000),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SlideTransition(
                  position: _offsetAnimation,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 24.w),
                        height: 233.h,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(38))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            homeItem(
                              imagePath: ImagesRes.icNewChatIcon,
                              title: StrRes.newChat,
                              content: StrRes.newChatContent,
                              onTap: w.toAddNewChat,
                            ),
                            homeDivider(),
                            homeItem(
                              imagePath: ImagesRes.icNewGroupIcon,
                              title: StrRes.newGroup,
                              content: StrRes.newGroupContent,
                              onTap: w.toAddFriend,
                            ),
                            homeDivider(),
                            homeItem(
                              imagePath: ImagesRes.icNewContactIcon,
                              title: StrRes.newContact,
                              content: StrRes.newContactContent,
                              onTap: w.toAddFriend,
                            ),
                          ],
                        )),
                  )),
              SizedBox(
                height: 15.w,
              ),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StrRes.cancel,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget homeItem({
    required String imagePath,
    required String title,
    required String content,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          children: [
            SvgPicture.asset(
              imagePath,
              width: 32.w,
            ),
            SizedBox(
              width: 14.w,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                        fontSize: 14.sp, color: const Color(0xFF707070)),
                  )
                ]),
          ],
        ),
      ),
    );
  }

  Widget homeDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: const Color(0xFFF0F0F0),
    );
  }
}
