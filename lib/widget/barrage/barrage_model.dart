import 'package:flutter/material.dart';

import '../../models/user_story.dart';
import 'barrage_config.dart';
class BarrageModel {
  UniqueKey id;
  UserStoryComment comment;
  double offsetY;
  double runDistance = 0;
  double everyFrameRunDistance;
  Size barrageSize;

  BarrageModel({
    required this.id,
    required this.comment,
    required this.offsetY,
    required this.everyFrameRunDistance,
    required this.runDistance,
    required this.barrageSize,
    required int offsetMS,
  }) {
    runDistance = (offsetMS / BarrageConfig.unitTimer) * everyFrameRunDistance;
  }

  /// 弹幕的x轴位置
  double get offsetX => runDistance - barrageSize.width;

  /// 弹幕最大可跑距离 弹幕宽度+墙宽度
  double get maxRunDistance => barrageSize.width + BarrageConfig.areaSize.width;

  /// 弹幕整体脱离右边墙壁
  bool get allOutRight => runDistance > barrageSize.width;

  /// 弹幕整体离开屏幕
  bool get allOutLeave => runDistance > maxRunDistance;

  /// 剩余离开的距离
  double get remainderDistance => needRunDistance - runDistance;

  /// 需要走的距离
  double get needRunDistance =>
      BarrageConfig.areaSize.width + barrageSize.width;

  /// 离开屏幕剩余需要的时间
  double get leaveScreenRemainderTime =>
      remainderDistance / everyFrameRunDistance;

  /// 弹幕执行下一帧
  void runNextFrame() {
    runDistance += everyFrameRunDistance * BarrageConfig.barrageRate;
  }
}

class BarrageManager {
  Map<UniqueKey, BarrageModel> _barrages = {};

  List<BarrageModel> get barrages => _barrages.values.toList();

  List<UniqueKey> get barrageKeys => _barrages.keys.toList();

  Map<UniqueKey, BarrageModel> get barragesMap => _barrages;

  /// 记录弹幕到map中
  recordBarrage(BarrageModel barrage) {
    _barrages[barrage.id] = barrage;
  }

  void removeBarrageByKey(UniqueKey id) => _barrages.remove(id);

  void removeAllBarrage() {
    _barrages = {};
  }

  BarrageModel initBarrage({
    required UserStoryComment comment,
    required double offsetY,
    required double everyFrameRunDistance,
    required double runDistance,
    required Size barrageSize,
    required int offsetMS,
  }) {
    UniqueKey barrageId = UniqueKey();
    BarrageModel barrage = BarrageModel(
      id: barrageId,
      comment: comment,
      offsetY: offsetY,
      everyFrameRunDistance: everyFrameRunDistance,
      runDistance: runDistance,
      barrageSize: barrageSize,
      offsetMS: offsetMS,
    );
    recordBarrage(barrage);
    return barrage;
  }
}
