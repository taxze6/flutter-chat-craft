import 'package:flutter/material.dart';
import 'fluent_data.dart';
import 'svg_icon_base.dart';

class FluentUiEmojiIcon extends StatelessWidget {
  const FluentUiEmojiIcon({super.key, required this.fl, this.h, this.w});

  final FluentData fl;
  final double? h;
  final double? w;

  @override
  Widget build(BuildContext context) {
    return SvgIconBase(raw: fl.raw, h: h, w: w);
  }
}
