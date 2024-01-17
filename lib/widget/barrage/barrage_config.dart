import 'package:flutter/material.dart';

import 'barrage_model.dart';

class BarrageConfig {
  // 帧率
  static int frameRate = 60;

  // 单位帧率所需要的时间
  static int unitTimer = 1000 ~/ BarrageConfig.frameRate;

  static int baseRunDistance = 1;

  static int everyFrameRateRunDistanceScale = 150;

  static bool pause = false;

  //显示区域
  static Size areaSize = const Size(0, 0);

  //弹幕移动倍速，默认为1
  static double barrageRate = 1.0;

  //弹幕单击事件
  static late Function(BarrageModel) bulletTapCallBack;
}
