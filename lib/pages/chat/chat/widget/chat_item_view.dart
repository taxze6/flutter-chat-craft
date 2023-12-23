import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/chat_single_layout.dart';

import 'chat_text.dart';

class ChatItemView extends StatefulWidget {
  const ChatItemView({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  bool get isFromMsg => widget.message.formId != GlobalData.userInfo.userID;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildItemView(),
    );
  }

  Widget buildItemView() {
    Widget child = Container();
    switch (widget.message.contentType) {
      case MessageType.text:
        {
          child = ChatSingleLayout(
            isFromMsg: isFromMsg,
            child: ChatText(
              text: widget.message.content,
            ),
          );
        }
        break;
    }
    return child;
  }
}
