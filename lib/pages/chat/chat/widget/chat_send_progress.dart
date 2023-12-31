import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  double _progress = 100.0;
  StreamSubscription? _progressSubs;

  @override
  void initState() {
    super.initState();
    _progressSubs = widget.msgProgressControllerStream
        .where((event) => widget.msgId == event.msgId)
        .listen((event) {
      if (!mounted) return;
      setState(() {
        _progress = event.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubs?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _progress != 100.0,
      child: Container(
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Column(
          children: [
            CircularProgressIndicator(
              value: _progress,
            ),
            Text(
              "${_progress.toStringAsFixed(2)}%",
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
