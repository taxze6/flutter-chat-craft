import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_logic.dart';
import 'package:flutter_chat_craft/pages/chat/widget/conversation_item_view.dart';
import 'package:flutter_chat_craft/pages/chat/widget/dashed_circle_border.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/widget/toast_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../im/im_utils.dart';
import '../../res/images.dart';
import '../../utils/touch_close_keyboard.dart';
import '../../widget/avatar_widget.dart';
import 'widget/appbar_title.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final conversationLogic = Get.find<ConversationLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
        child: Scaffold(
            appBar: titleAppBar(),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     conversationLogic.testMessage();
            //   },
            // ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                SlidableAutoCloseBehavior(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    // header: Container(
                    //   child: Text("111"),
                    // ),
                    // footer: IMWidget.buildFooter(),
                    controller: conversationLogic.refreshController,
                    onRefresh: conversationLogic.onRefresh,
                    onLoading: conversationLogic.onLoading,
                    child: _buildListView(),
                  ),
                ),
              ],
            )));
  }

  PreferredSizeWidget titleAppBar() => AppBar(
        title: const AppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              ImagesRes.icSearch,
            ),
          ),
        ],
      );

  Widget _buildListView() => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 18.w),
            sliver: SliverToBoxAdapter(
              child: topUser(),
            ),
          ),
          friendConversationList(),
        ],
      );

  Widget topUser() {
    return SizedBox(
      height: 90.w,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: conversationLogic.toNewChat,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashedCircleBorder(
                    color: const Color(0xFFE2E2E2),
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      padding: EdgeInsets.all(20.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        ImagesRes.icAdd,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    StrRes.newChat,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<ConversationLogic>(
                id: "friendList",
                builder: (logic) {
                  return ListView.builder(
                    itemCount: logic.friendsInfo.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) =>
                        userChat(logic.friendsInfo[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget userChat(UserInfo userInfo) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarWidget(
            imageSize: Size(60.w, 60.w),
            imageUrl: userInfo.avatar,
            radius: 60.w,
            onTap: () => conversationLogic.startUserInfo(userInfo),
          ),
          Text(
            userInfo.userName,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget chatTitle() {
    return Row(
      children: [
        Text(
          StrRes.chats,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        )
      ],
    );
  }

  Widget friendConversationList() {
    return Obx(() => SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: conversationLogic.conversationsInfo.length,
            (context, index) => ConversationItemView(
              userInfo: conversationLogic.conversationsInfo[index].userInfo,
              content: conversationLogic.conversationsInfo[index].previewText,
              // timeStr:
              //     conversationLogic.conversationsInfo[index].message.sendTime ??
              //         "",
              timeStr: IMUtils.formatTime(conversationLogic
                      .conversationsInfo[index].message.sendTime) ??
                  "",
              onTap: () => conversationLogic.toChat(index),
              slideActions: [
                SlideItemInfo(
                  flex: conversationLogic.isPinned(index) ? 3 : 2,
                  text: conversationLogic.isPinned(index)
                      ? StrRes.cancelTop
                      : StrRes.top,
                  colors: pinColors,
                  width: 77.w,
                  onTap: () {
                    ToastUtils.toastText(StrRes.notImplemented);
                  },
                ),
                SlideItemInfo(
                  flex: 2,
                  text: StrRes.remove,
                  colors: deleteColors,
                  width: 77.w,
                  onTap: () => conversationLogic.deleteConversation(
                      conversationLogic.conversationsInfo[index].userInfo),
                ),
              ],
            ),
          ),
        ));
  }
}
