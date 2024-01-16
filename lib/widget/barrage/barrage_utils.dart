import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_craft/widget/test_barrage/barrage_config.dart';
import 'package:flutter_chat_craft/widget/test_barrage/barrage_track.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BarrageUtils {
  static Size getDanmakuBulletSizeByText(String text) {
    const constraints = BoxConstraints(
      maxWidth: 999.0, // maxWidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14.sp,
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

  // 根据文字长度计算每一帧需要run多少距离
  static double getBulletEveryFrameRateRunDistance(double bulletWidth) {
    assert(bulletWidth > 0);
    return BarrageConfig.baseRunDistance +
        (bulletWidth / BarrageConfig.everyFrameRateRunDistanceScale);
  }

  // 算轨道相对可用区域是否溢出
  static bool isEnableTrackOverflowArea(BarrageTrack track) =>
      track.offsetTop + track.trackHeight > BarrageConfig.showAreaHeight;

  // 子弹剩余多少帧离开屏幕
  static double remainderTimeLeaveScreen(
      double runDistance, double textWidth, double everyFramerateDistance) {
    assert(runDistance >= 0);
    assert(textWidth >= 0);
    assert(everyFramerateDistance > 0);
    double remainderDistance =
        (BarrageConfig.areaSize.width + textWidth) - runDistance;
    return remainderDistance / everyFramerateDistance;
  }

}
