import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_utils.dart';
import 'barrage_item.dart';

class BarrageConfig {
  // 帧率
  static int framerate = 60;

  // 单位帧率所需要的时间
  static int unitTimer = 1000 ~/ BarrageConfig.framerate;

  static Duration bulletBaseShowDuration = const Duration(seconds: 3);
  static double bulletLableSize = 14;

  static double bulletRate = 1.0;

  static Function(BarrageModel)? bulletTapCallBack;

  static Size areaSize = const Size(0, 0);

  // 展示区域百分比
  static double showAreaPercent = 1.0;

  static double opacity = 1.0;

  static bool pause = false;

  static const Color defaultColor = Colors.black;

  static int baseRunDistance = 1;

  static int everyFrameRateRunDistanceScale = 150;

  /// 弹幕场景基于子组件高度的偏移量。是由于子组件高度不一定能整除轨道高度 为了居中展示 需要有一个偏移量
  static double areaOfChildOffsetY = 0;

  // 展示高度
  static double get showAreaHeight =>
      BarrageConfig.areaSize.height * BarrageConfig.showAreaPercent;

  /// 获取弹幕场景基于子组件高度的偏移量。为了居中展示
  static double getAreaOfChildOffsetY({Size? textSize}) {
    Size size = textSize ?? BarrageUtils.getDanmakuBulletSizeByText('s');

    return (BarrageConfig.areaSize.height % size.height) / 2;
  }
}
