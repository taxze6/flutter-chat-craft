import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_reply_emoji.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_single_layout.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_typing_view.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_picture.dart';
import 'chat_quote_text.dart';
import 'chat_text.dart';
import 'chat_voice_view.dart';
import 'menu/chat_menu.dart';
import 'menu/message_custom_popup.dart';

class MsgStreamEv<T> {
  final String msgId;
  final T value;

  MsgStreamEv({required this.msgId, required this.value});
}

class ChatItemView extends StatefulWidget {
  const ChatItemView({
    Key? key,
    required this.index,
    required this.message,
    required this.msgSendStatusSubjectStream,
    required this.msgSendProgressSubjectStream,
    required this.clickSubjectController,
    required this.onFailedResend,
    required this.onTapCopyMenu,
    required this.onTapReplyMenu,
    required this.replyEmoji,
  }) : super(key: key);
  final int index;
  final Message message;

  final Stream<MsgStreamEv<bool>> msgSendStatusSubjectStream;
  final Stream<MsgStreamEv<double>> msgSendProgressSubjectStream;
  final StreamController<int> clickSubjectController;

  /// Retry on failure.
  final Function() onFailedResend;

  /// Click the copy button event on the menu
  final Function() onTapCopyMenu;

  /// Click the reply button event on the menu
  final Function() onTapReplyMenu;

  final Function(String value) replyEmoji;

  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  bool get isFromMsg => widget.message.formId != GlobalData.userInfo.userID;

  final _popupCtrl = MessageCustomPopupMenuController();

  @override
  void dispose() {
    _popupCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildItemView();
  }

  Widget buildItemView() {
    Widget child = const SizedBox();
    switch (widget.message.contentType) {
      case MessageType.text:
        {
          child = _buildCommonItemView(
            child: ChatText(
              isFromMsg: isFromMsg,
              text: widget.message.content,
            ),
          );
        }
        break;
      case MessageType.picture:
        {
          child = _buildCommonItemView(
            child: ChatPictureView(
              msgId: widget.message.msgId!,
              msgProgressControllerStream: widget.msgSendProgressSubjectStream,
              imgUrl: widget.message.image!.image!,
              isFromMsg: isFromMsg,
              imageWidth: widget.message.image!.imageWidth!,
              imageHeight: widget.message.image!.imageHeight!,
            ),
          );
        }
        break;
      case MessageType.voice:
        {
          var sound = widget.message.sound;
          child = _buildCommonItemView(
            child: ChatVoiceView(
              isReceived: isFromMsg,
              soundPath: sound?.soundPath,
              soundUrl: sound?.sourceUrl,
              duration: sound?.duration,
              index: widget.index,
              clickStream: widget.clickSubjectController.stream,
            ),
          );
        }
        break;
      case MessageType.quote:
        {
          child = _buildCommonItemView(
            child: ChatQuoteText(
              message: widget.message,
              isFromMsg: isFromMsg,
            ),
          );
        }
        break;
      case MessageType.typing:
        {
          child = _buildCommonItemView(child: const ChatTypingWidget());
        }
        break;
    }

    if (widget.message.replyEmojis!.isNotEmpty) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isFromMsg ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          child,
          ChatReplyEmoji(
            replyEmoji: widget.message.replyEmojis,
            isFromMsg: isFromMsg,
          ),
        ],
      );
    }
    return child;
  }

  // Widget _menuBuilder() => ChatLongPressMenu(
  //       controller: _popupCtrl,
  //       menus: _menusItem(),
  //       menuStyle: ChatMenuStyle(
  //         crossAxisCount: 4,
  //         mainAxisSpacing: 13.w,
  //         crossAxisSpacing: 12.h,
  //         radius: 4,
  //         background: const Color(0xFF1D1D1D),
  //       ),
  //     );

  Widget _buildCommonItemView({
    required Widget child,
  }) =>
      ChatSingleLayout(
        index: widget.index,
        isFromMsg: isFromMsg,
        clickSink: widget.clickSubjectController.sink,
        message: widget.message,
        isSending: widget.message.status == MessageStatus.sending,
        isSendFailed: widget.message.status == MessageStatus.failed,
        popupCtrl: _popupCtrl,
        menuBuilder: _menusItem(),
        replyEmoji: widget.replyEmoji,
        child: child,
      );

  List<MenuInfo> _menusItem() => [
        MenuInfo(
          icon: SvgPicture.asset(
            ImagesRes.icMessageReply,
            width: 25.w,
            height: 23.w,
          ),
          text: StrRes.reply,
          onTap: widget.onTapReplyMenu,
        ),
        // MenuInfo(
        //   icon: SvgPicture.asset(
        //     ImagesRes.icMessageCopy,
        //     width: 23.w,
        //     height: 23.w,
        //   ),
        //   text: StrRes.copy,
        //   onTap: widget.onTapCopyMenu,
        // ),
        MenuInfo(
          icon: SvgPicture.asset(
            ImagesRes.icMessageForWord,
            width: 23.w,
            height: 23.w,
          ),
          text: StrRes.forward,
          onTap: widget.onTapCopyMenu,
        ),
      ];
}
