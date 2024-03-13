import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconBase extends StatelessWidget {
  const SvgIconBase({
    super.key,
    required this.raw,
    this.h,
    this.w,
  });
  final String raw;
  final double? h;
  final double? w;

  @override
  Widget build(BuildContext context) {
    return SvgPicture(
      SvgStringLoader(raw),
      width: w,
      height: h,
    );
  }
}
