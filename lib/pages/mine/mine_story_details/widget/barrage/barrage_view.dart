import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BarrageView extends StatefulWidget {
  const BarrageView({Key? key}) : super(key: key);

  @override
  State<BarrageView> createState() => _BarrageViewState();
}

class _BarrageViewState extends State<BarrageView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [],
    );
  }

  static Size getDanmakuBulletSizeByText(String text) {
    const constraints = BoxConstraints(
      maxWidth: 999.0, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    double w = renderParagraph.getMinIntrinsicWidth(14).ceilToDouble();
    double h = renderParagraph.getMinIntrinsicHeight(999).ceilToDouble();
    return Size(w, h);
  }
}
