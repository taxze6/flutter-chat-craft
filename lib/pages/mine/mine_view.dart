import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/mine/mine_logic.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key, required this.controller}) : super(key: key);
  final MineLogic controller;

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
                        if (mineLogic.isSelf)
                          myProfile()
                        else
                          otherUserInteractionModule(),
                        divider(),
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

  ///Display the widget when the account belongs to the user.
  Widget myProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.w),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StrRes.myProfile,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xFFC4C4C4),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFC4C4C4),
              size: 10.w,
            ),
          ],
        ),
      ),
    );
  }

  ///Display when it is information of other users.
  Widget otherUserInteractionModule() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: otherUserInteractionItem(
              iconImage: ImagesRes.icLike,
              itemText: '222',
              onTap: () {},
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: otherUserInteractionItem(
                iconImage: ImagesRes.icSend,
                itemText: StrRes.sendMessage,
                onTap: mineLogic.toChat,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: otherUserInteractionItem(
              iconImage: ImagesRes.icAudio,
              itemText: StrRes.audio,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget otherUserInteractionItem({
    required String iconImage,
    required String itemText,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(26.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(iconImage),
              SizedBox(
                width: 6.w,
              ),
              Text(
                itemText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Divider(
      color: Color(0xFFEFEFEF),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
