import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/chat_logic.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/widget/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../im/im_utils.dart';
import '../../../utils/touch_close_keyboard.dart';
import '../../../widget/water_mark_view.dart';
import 'widget/chat_input_box_view.dart';
import 'widget/chat_item_view.dart';
import 'widget/chat_listview.dart';
import 'widget/chat_voice_record_widget/chat_voice_record_layout.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatLogic = Get.find<ChatLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
        child: ChatVoiceRecordLayout(
      builder: (recordBar) {
        return Obx(() => Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: singleChatAppBar(
                title: chatLogic.userInfo.userName,
                userImage: chatLogic.userInfo.avatar,
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                child: WaterMarkBgView(
                  text: "",
                  // text: GlobalData.userInfo.userName,
                  child: Column(
                    children: [
                      Expanded(
                          child: ChatListView(
                              // onTouch: () => chatLogic.closeToolbox(),
                              itemCount: chatLogic.messageList.length,
                              controller: chatLogic.scrollController,
                              onScrollDownLoad: () =>
                                  chatLogic.getHistoryMsgList(),
                              itemBuilder: (_, index) => Obx(
                                    () => Column(
                                      children: [
                                        onBuildTime(index),
                                        itemView(
                                          ValueKey(chatLogic
                                              .indexOfMessage(index)
                                              .msgId),
                                          index,
                                          chatLogic.indexOfMessage(index),
                                        ),
                                      ],
                                    ),
                                  ))),
                      ChatInputBoxView(
                        quoteContent: chatLogic.quoteContent.value,
                        textEditingController: chatLogic.textEditingController,
                        textFocusNode: chatLogic.textFocusNode,
                        onToolsBtnTap: () => chatLogic.showToolsDialog(context),
                        onSendTap: () => chatLogic.sendTextMessage(),
                        onClearQuote: () => chatLogic.onTapReplyMenu(null),
                        voiceRecordBar: recordBar,
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
      onCompleted: (fileDuration, path, fileSize) {
        chatLogic.sendVoice(
            duration: fileDuration, path: path, fileSize: fileSize);
      },
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

  Widget itemView(key, index, Message message) => ChatItemView(
        key: key,
        index: index,
        message: message,
        msgSendStatusSubjectStream: chatLogic.msgSendStatusSubject.stream,
        msgSendProgressSubjectStream: chatLogic.msgProgressController.stream,
        clickSubjectController: chatLogic.clickSubjectController,
        onFailedResend: () {},
        onTapReplyMenu: () => chatLogic.onTapReplyMenu(message),
        onTapCopyMenu: () {},
        replyEmoji: (String value) => chatLogic.onReplyEmoji(value, message),
      );

  Widget onBuildTime(index) {
    if (index != 0) {
      var timeDiff = (DateTime.parse(chatLogic.indexOfMessage(index).sendTime!)
                  .millisecondsSinceEpoch ~/
              1000) -
          (DateTime.parse(chatLogic.indexOfMessage(index - 1).sendTime!)
                  .millisecondsSinceEpoch ~/
              1000);
      if (timeDiff < 10 * 60) {
        return const SizedBox();
      }

      var nearTime = chatLogic.messageList[index].sendTime;

      return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(0x44, 0x66, 0x66, 0x66),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.w),
        child: Text(IMUtils.formatTime(nearTime) ?? ""),
      );
    } else {
      return const SizedBox();
    }
  }
}
