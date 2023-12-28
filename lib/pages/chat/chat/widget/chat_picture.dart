import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chat_item_view.dart';
import 'chat_send_progress.dart';

class ChatPictureView extends StatefulWidget {
  const ChatPictureView({
    Key? key,
    required this.msgId,
    required this.width,
    required this.height,
    required this.imgUrl,
    required this.isFromMsg,
    required this.msgProgressControllerStream,
  }) : super(key: key);

  final String msgId;
  final double width;
  final double height;
  final String imgUrl;
  final bool isFromMsg;
  final Stream<MsgStreamEv<double>> msgProgressControllerStream;

  @override
  State<ChatPictureView> createState() => _ChatPictureViewState();
}

class _ChatPictureViewState extends State<ChatPictureView> {
  late double _trulyWidth;
  late double _trulyHeight;
  late String _imgPath;
  late bool showFileOrNetWorkImg;

  @override
  void initState() {
    super.initState();
    _trulyWidth = widget.width;
    _trulyHeight = widget.height;
    _imgPath = widget.imgUrl;
    showFileOrNetWorkImg =
        _imgPath.startsWith('http://') || _imgPath.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    var child = _buildChildView();
    return child;
  }

  Widget _buildChildView() {
    Widget child;
    if (showFileOrNetWorkImg) {
      child = _urlView(url: _imgPath);
    } else {
      child = _pathView(path: _imgPath);
    }
    return Container(
      margin: EdgeInsets.only(bottom: 6.w),
      child: child,
    );
  }

  Widget _pathView({required String path}) => Stack(
        children: [
          Container(
            height: _trulyHeight,
            width: _trulyWidth,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          ChatSendProgressView(
            height: _trulyHeight,
            width: _trulyWidth,
            msgProgressControllerStream: widget.msgProgressControllerStream,
            msgId: widget.msgId,
          ),
        ],
      );

  Widget _urlView({required String url}) {
    return Container(
      height: _trulyHeight,
      width: _trulyWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _errorIcon() => SvgPicture.asset(StrRes.meMe);
}
