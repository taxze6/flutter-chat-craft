import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/chat_logic.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/touch_close_keyboard.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../widget/water_mark_view.dart';
import 'widget/chat_input_box_view.dart';
import 'widget/chat_item_view.dart';
import 'widget/chat_listview.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatLogic = Get.find<ChatLogic>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
      appBar: singleChatAppBar(
          title: chatLogic.userInfo.userName,
          userImage: chatLogic.userInfo.avatar),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: WaterMarkBgView(
          text: "111",
          child: Column(
            children: [
              Expanded(
                  child: ChatListView(
                // onTouch: () => chatLogic.closeToolbox(),
                itemCount: chatLogic.messageList.length,
                controller: chatLogic.scrollController,
                onScrollDownLoad: () => chatLogic.getHistoryMsgList(),
                itemBuilder: (_, index) => itemView(
                  index,
                  chatLogic.messageList[index],
                ),
              )),
              ChatInputBoxView(
                textEditingController: chatLogic.textEditingController,
                textFocusNode: chatLogic.textFocusNode,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  PreferredSizeWidget singleChatAppBar({
    required String title,
    required String userImage,
  }) {
    return AppBar(
      leadingWidth: 44.w,
      titleSpacing: 0,
      leading: IconButton(
        icon: SvgPicture.asset(ImagesRes.back),
        onPressed: () => Get.back(),
      ),
      elevation: 1,
      title: Row(
        children: [
          AvatarWidget(
            imageSize: Size(36.w, 36.w),
            imageUrl: userImage,
            radius: 36.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                ),
                Text(
                  StrRes.online,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: PageStyle.chatColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(ImagesRes.icPhone),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(ImagesRes.icMore),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget itemView(index, Message message) => ChatItemView(
        message: message,
      );
}
