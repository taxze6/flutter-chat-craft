import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_item_view.dart';

class ChatSendProgressView extends StatefulWidget {
  const ChatSendProgressView({
    Key? key,
    required this.msgId,
    required this.width,
    required this.height,
    required this.msgProgressControllerStream,
  }) : super(key: key);
  final String msgId;
  final double width;
  final double height;
  final Stream<MsgStreamEv<double>> msgProgressControllerStream;

  @override
  State<ChatSendProgressView> createState() => _ChatSendProgressViewState();
}

class _ChatSendProgressViewState extends State<ChatSendProgressView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: widget.msgProgressControllerStream
          .where((event) => widget.msgId == event.msgId)
          .map((event) => event.value),
      initialData: 0.0,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        final double progress = snapshot.data ?? 0.0;
        return Visibility(
          visible: progress != 100.0,
          child: Container(
            height: widget.height,
            width: widget.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.5),
            ),
            child: CircularProgressIndicator(
              value: progress,
            ),
          ),
        );
      },
    );
  }
}
