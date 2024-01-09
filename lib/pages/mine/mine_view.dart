import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
              child: GestureDetector(
                onTap: () {},
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
                          storyTitle(),
                          stories(),
                          preferencesTitle(),
                          preferencesItem(
                            icon: ImagesRes.icFriendSetting,
                            title: StrRes.friendSetting,
                          ),
                          preferencesItem(
                            icon: ImagesRes.icShareApp,
                            title: StrRes.shareApp,
                          ),
                          appVersion(),
                        ],
                      ),
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
            child: Obx(
              () => otherUserInteractionItem(
                iconImage: ImagesRes.icLike,
                itemText: mineLogic.storyLike.value.toString(),
                onTap: () {},
              ),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: const Divider(
        color: Color(0xFFEFEFEF),
      ),
    );
  }

  Widget storyTitle() {
    return Row(
      children: [
        Text(
          StrRes.story,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        GestureDetector(
            onTap: () {},
            child: Text(
              StrRes.viewAllStory,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB4B4B4),
              ),
            )),
      ],
    );
  }

  Widget stories() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.w,
      ),
      child: Obx(() => mineLogic.userStories.isEmpty
          ? Row(
              children: [
                Text(
                  StrRes.noStory,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            )
          : SizedBox(
              height: 175.h,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: mineLogic.userStories.length,
                  itemBuilder: (_, index) {
                    var data = mineLogic.userStories[index];
                    return LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: GestureDetector(
                            onTap: () => mineLogic.startMineStoryDetails(data),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: data.media![0],
                                  width: 130.w,
                                  height: constraints.maxHeight,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.close,
                                    )),
                                  ),
                                ),
                                Positioned(
                                    top: constraints.maxHeight - 34,
                                    left: 5,
                                    right: 5,
                                    child: Text(
                                      (data.content?.length ?? 0) > 30
                                          ? '${data.content!.substring(0, 30)}...'
                                          : (data.content ?? ""),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            )),
    );
  }

  Widget preferencesTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Row(
        children: [
          Text(
            StrRes.preferences,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget preferencesItem({
    required String icon,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 18.w,
                  height: 18.w,
                ),
                SizedBox(
                  width: 18.w,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: pi,
                  child: SvgPicture.asset(
                    ImagesRes.back,
                    width: 18.w,
                    height: 18.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFD2D2D2),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFEFEFEF),
          ),
        ],
      ),
    );
  }

  Widget appVersion() {
    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 12),
      child: Center(
        child: Text(
          "ChatCraft v1.0.0",
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFFA6A6A6),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
