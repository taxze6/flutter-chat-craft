import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

myAppBar({
  required String title,
  required GestureTapCallback backOnTap,
  Color color = const Color(0xFF000000),
  Color? backColor,
}) {
  return AppBar(
    backgroundColor: backColor,
    leading: IconButton(
      icon: SvgPicture.asset(
        ImagesRes.icBackLeft,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
      onPressed: backOnTap,
    ),
    scrolledUnderElevation: 0,
    title: Text(
      title,
      style: TextStyle(
        color: color,
      ),
    ),
    centerTitle: true,
  );
}
