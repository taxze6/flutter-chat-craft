import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/config.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_single_layout.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_typing_view.dart';

import 'chat_picture.dart';
import 'chat_text.dart';
import 'chat_voice_view.dart';

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
    this.onFailedResend,
  }) : super(key: key);
  final int index;
  final Message message;

  final Stream<MsgStreamEv<bool>> msgSendStatusSubjectStream;
  final Stream<MsgStreamEv<double>> msgSendProgressSubjectStream;
  final StreamController<int> clickSubjectController;

  /// Retry on failure.
  final Function()? onFailedResend;

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
            index: widget.index,
            isFromMsg: isFromMsg,
            clickSink: widget.clickSubjectController.sink,
            sendStatusStream: widget.msgSendStatusSubjectStream,
            message: widget.message,
            isSending: widget.message.status == MessageStatus.sending,
            isSendFailed: widget.message.status == MessageStatus.failed,
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
            index: widget.index,
            isFromMsg: isFromMsg,
            clickSink: widget.clickSubjectController.sink,
            message: widget.message,
            isSending: widget.message.status == MessageStatus.sending,
            isSendFailed: widget.message.status == MessageStatus.failed,
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
          child = ChatSingleLayout(
              index: widget.index,
              isFromMsg: isFromMsg,
              clickSink: widget.clickSubjectController.sink,
              sendStatusStream: widget.msgSendStatusSubjectStream,
              message: widget.message,
              isSending: widget.message.status == MessageStatus.sending,
              isSendFailed: widget.message.status == MessageStatus.failed,
              child: ChatVoiceView(
                isReceived: isFromMsg,
                soundPath: sound?.soundPath,
                soundUrl: sound?.sourceUrl,
                duration: sound?.duration,
                index: widget.index,
                clickStream: widget.clickSubjectController.stream,
              ));
        }
        break;
      case MessageType.typing:
        {
          print("${widget.message.formId} ${GlobalData.userInfo.userID}");
          child = ChatSingleLayout(
            index: widget.index,
            isFromMsg: isFromMsg,
            clickSink: widget.clickSubjectController.sink,
            sendStatusStream: widget.msgSendStatusSubjectStream,
            message: widget.message,
            isSending: widget.message.status == MessageStatus.sending,
            isSendFailed: widget.message.status == MessageStatus.failed,
            child: ChatSingleLayout(
              index: widget.index,
              isFromMsg: isFromMsg,
              clickSink: widget.clickSubjectController.sink,
              message: widget.message,
              isSending: widget.message.status == MessageStatus.sending,
              isSendFailed: widget.message.status == MessageStatus.failed,
              child: const ChatTypingWidget(),
            ),
          );
        }
    }

    return child;
  }
}
