import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../widget/aspect_ratio_image.dart';
import '../../../../widget/photo_browser.dart';
import 'chat_item_view.dart';
import 'chat_send_progress.dart';

class ChatPictureView extends StatelessWidget {
  const ChatPictureView(
      {super.key,
      required this.msgId,
      required this.imgUrl,
      required this.isFromMsg,
      required this.msgProgressControllerStream});

  final String msgId;
  final String imgUrl;
  final bool isFromMsg;
  final Stream<MsgStreamEv<double>> msgProgressControllerStream;

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
            Navigator.of(context).push(FadeRoute(
              page: PhotoBrowser(
                imgDataArr: [imgPath],
                index: 0,
                onLongPress: () {},
              ),
            ));
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
    return child;
  }

  Widget _pathView({required String path}) => Stack(
        children: [
          AspectRatioImage.file(
            imageFile: File(path),
            fileBuilder: (context, snapshot, url) {
              //Image maximum size
              double width = 0.5.sw;
              double height = 0.25.sh;

              double actualWidth = snapshot.data?.width.toDouble() ?? 0.0;
              double actualHeight = snapshot.data?.height.toDouble() ?? 0.0;

              double scale = 1.0;
              if (actualWidth > width || actualHeight > height) {
                double widthScale = width / actualWidth;
                double heightScale = height / actualHeight;
                //Choose the smaller ratio as the scaling factor.
                scale = widthScale < heightScale ? widthScale : heightScale;
              }

              width = actualWidth * scale;
              height = actualHeight * scale;
              return Stack(
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        image: DecorationImage(
                          image: FileImage(url),
                          fit: BoxFit.fill,
                        )),
                  ),
                  ChatSendProgressView(
                    width: width,
                    height: height,
                    msgProgressControllerStream: msgProgressControllerStream,
                    msgId: msgId,
                  ),
                ],
              );
            },
          ),
        ],
      );

  Widget _urlView({required String url}) {
    return AspectRatioImage.network(
      url: url,
      builder: (context, snapshot, url) {
        //Image maximum size
        double width = 0.5.sw;
        double height = 0.25.sh;

        double actualWidth = snapshot.data?.width.toDouble() ?? 0.0;
        double actualHeight = snapshot.data?.height.toDouble() ?? 0.0;

        double scale = 1.0;
        if (actualWidth > width || actualHeight > height) {
          double widthScale = width / actualWidth;
          double heightScale = height / actualHeight;
          //Choose the smaller ratio as the scaling factor.
          scale = widthScale < heightScale ? widthScale : heightScale;
        }

        width = actualWidth * scale;
        height = actualHeight * scale;
        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
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
      },
    );
  }

  Widget _errorIcon() => SvgPicture.asset(StrRes.meMe);
}
