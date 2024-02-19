import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../widget/aspect_ratio_image.dart';
import '../../../../widget/mimicking_hero_animation_image.dart';
import '../../../../widget/photo_browser.dart';
import 'chat_item_view.dart';
import 'chat_send_progress.dart';

class ChatPictureView extends StatelessWidget {
  const ChatPictureView(
      {super.key,
      required this.msgId,
      required this.imgUrl,
      required this.isFromMsg,
      required this.msgProgressControllerStream,
      required this.imageWidth,
      required this.imageHeight});

  final String msgId;
  final String imgUrl;
  final bool isFromMsg;
  final Stream<MsgStreamEv<double>> msgProgressControllerStream;

  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    String imgPath = imgUrl;
    bool showFileOrNetWorkImg =
        imgPath.startsWith('http://') || imgPath.startsWith('https://');

    Widget child = _buildChildView(imgPath, showFileOrNetWorkImg);
    return Padding(
      padding: EdgeInsets.only(bottom: 6.w),
      child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(FadeRoute(
            //   page: PhotoBrowser(
            //     imgDataArr: [imgPath],
            //     index: 0,
            //     onLongPress: () {},
            //   ),
            // ));
          },
          child: child),
    );
  }

  Widget _buildChildView(String imgPath, bool showFileOrNetWorkImg) {
    Widget child;
    if (showFileOrNetWorkImg) {
      child = _urlView(url: imgPath);
    } else {
      child = _pathView(path: imgPath);
    }
    return MimickingHeroAnimationImage(
      offset: Offset.zero,
      child: child,
    );
  }

  Widget _pathView({required String path}) => Stack(
        children: [
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                image: DecorationImage(
                  image: FileImage(File(path)),
                  fit: BoxFit.fill,
                )),
          ),
          ChatSendProgressView(
            width: imageWidth,
            height: imageHeight,
            msgProgressControllerStream: msgProgressControllerStream,
            msgId: msgId,
          ),
        ],
      );

  Widget _urlView({required String url}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: imageWidth,
      height: imageHeight,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.grey.shade100,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _errorIcon() => SvgPicture.asset(StrRes.meMe);
}
