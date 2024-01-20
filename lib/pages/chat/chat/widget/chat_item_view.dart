import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/config.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_single_layout.dart';

import 'chat_picture.dart';
import 'chat_text.dart';
import 'chat_voice_view.dart';

class MsgStreamEv<T> {
  final String msgId;
  final T value;

  MsgStreamEv({required this.msgId, required this.value});
}

class ChatItemView extends StatefulWidget {
  const ChatItemView(
      {Key? key,
      required this.message,
      required this.msgSendStatusSubjectStream,
      required this.msgSendProgressSubjectStream})
      : super(key: key);
  final Message message;

  final Stream<MsgStreamEv<bool>> msgSendStatusSubjectStream;

  final Stream<MsgStreamEv<double>> msgSendProgressSubjectStream;

  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  bool get isFromMsg => widget.message.formId != GlobalData.userInfo.userID;

  @override
  Widget build(BuildContext context) {
    return buildItemView();
  }

  Widget buildItemView() {
    Widget child = Container();
    switch (widget.message.contentType) {
      case MessageType.text:
        {
          child = ChatSingleLayout(
            isFromMsg: isFromMsg,
            child: ChatText(
              isFromMsg: isFromMsg,
              text: widget.message.content,
            ),
          );
        }
        break;
      case MessageType.picture:
        {
          child = ChatSingleLayout(
            isFromMsg: isFromMsg,
            child: ChatPictureView(
              msgId: widget.message.msgId!,
              msgProgressControllerStream: widget.msgSendProgressSubjectStream,
              imgUrl: widget.message.content!,
              isFromMsg: isFromMsg,
            ),
          );
        }
        break;
      case MessageType.voice:
        {
          var sound = widget.message.sound;
          child = ChatVoiceView(
            isReceived: isFromMsg,
            soundPath: sound?.soundPath,
            soundUrl: sound?.sourceUrl,
            duration: sound?.duration,
          );
        }
        break;
    }

    return child;
  }
}
