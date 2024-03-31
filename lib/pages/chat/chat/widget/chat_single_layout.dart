import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/pages/chat/chat/widget/menu/chat_menu.dart';
import 'chat_item_view.dart';
import 'chat_send_failed_view.dart';
import 'menu/message_custom_popup.dart';

enum BubbleType {
  send,
  receiver,
}

class ChatSingleLayout extends StatelessWidget {
  const ChatSingleLayout({
    Key? key,
    required this.popupCtrl,
    required this.index,
    required this.message,
    required this.child,
    required this.isFromMsg,
    required this.clickSink,
    this.sendStatusStream,
    this.onFailedResend,
    required this.isSending,
    required this.isSendFailed,
    required this.menuBuilder,
    required this.replyEmoji,
  }) : super(key: key);

  final MessageCustomPopupMenuController popupCtrl;

  final int index;

  final Message message;

  final Widget child;

  final List<MenuInfo> menuBuilder;

  final bool isFromMsg;

  final Sink<int> clickSink;

  final Stream<MsgStreamEv<bool>>? sendStatusStream;

  final bool isSending;

  final bool isSendFailed;

  /// Retry on failure.
  final Function()? onFailedResend;
  final Function(String value) replyEmoji;

  MainAxisAlignment get layoutAlignment =>
      isFromMsg ? MainAxisAlignment.start : MainAxisAlignment.end;

  Sink<int>? get _onItemClick => clickSink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onItemClick?.add(index),
      behavior: HitTestBehavior.deferToChild,
      child: buildContentView(),
    );
    // return Row(
    //   mainAxisAlignment: layoutAlignment,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     CustomPopupMenu(
    //       controller: popupCtrl,
    //       verticalMargin: 0,
    //       // horizontalMargin: null,
    //       horizontalMargin: 0,
    //       menuBuilder: menuBuilder,
    //       pressType: PressType.longPress,
    //       child: GestureDetector(
    //         onTap: () => _onItemClick?.add(index),
    //         behavior: HitTestBehavior.deferToChild,
    //         child: buildContentView(),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget buildContentView() {
    return Row(
      mainAxisAlignment: layoutAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _delayedStatusView(),
        ChatSendFailedView(
          msgId: message.msgId!,
          isReceived: isFromMsg,
          stream: sendStatusStream,
          isSendFailed: isSendFailed,
          onFailedResend: onFailedResend,
        ),
        // const SizedBox(
        //   width: 4,
        // ),
        MessageCustomPopupMenu(
          menuWidgets: menuBuilder,
          controller: popupCtrl,
          isFromMsg: isFromMsg,
          replyEmoji: replyEmoji,
          child: child,
        )
      ],
    );
  }

  Widget _delayedStatusView() => FutureBuilder(
        future: Future.delayed(
          Duration(seconds: (isSending && !isSendFailed) ? 1 : 0),
          () => isSending && !isSendFailed,
        ),
        builder: (_, AsyncSnapshot<bool> hot) => Visibility(
          visible:
              index == 0 ? (hot.data == true) : (isSending && !isSendFailed),
          // child: const CupertinoActivityIndicator(),
          child: const SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
}
