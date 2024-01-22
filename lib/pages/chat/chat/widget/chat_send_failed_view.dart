import 'dart:async';

import 'package:flutter/material.dart';
import 'chat_item_view.dart';

class ChatSendFailedView extends StatefulWidget {
  final String msgId;
  final bool isReceived;
  final Stream<MsgStreamEv<bool>>? stream;
  final bool isSendFailed;
  final Function()? onFailedResend;

  const ChatSendFailedView({
    Key? key,
    required this.msgId,
    required this.isReceived,
    this.isSendFailed = false,
    this.stream,
    this.onFailedResend,
  }) : super(key: key);

  @override
  _ChatSendFailedViewState createState() => _ChatSendFailedViewState();
}

class _ChatSendFailedViewState extends State<ChatSendFailedView> {
  late bool _failed;
  StreamSubscription? _statusSubs;

  @override
  void initState() {
    _failed = widget.isSendFailed;
    _statusSubs = widget.stream?.listen((event) {
      if (!mounted) return;
      if (widget.msgId == event.msgId) {
        setState(() {
          _failed = !event.value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _statusSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.isReceived && _failed,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onFailedResend,
        child: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      ),
    );
  }
}
