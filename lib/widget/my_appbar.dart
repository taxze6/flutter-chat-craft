import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

myAppBar({
  required String title,
  required GestureTapCallback backOnTap,
}) {
  return AppBar(
    leading: IconButton(
      icon: SvgPicture.asset(ImagesRes.icBackLeft),
      onPressed: backOnTap,
    ),
    title: Text(title),
    centerTitle: true,
  );
}
