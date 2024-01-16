import 'dart:async';

import 'package:flutter/material.dart';

import 'barrage_config.dart';
import 'barrage_model.dart';

class BarrageController {
  late Function setState;

  /// 是否暂停
  bool get isPause => BarrageConfig.pause;

  /// 是否初始化过
  bool isInit = false;

  /// 弹幕定时器
  Timer? _timer;
  BarrageManager barrageManager = BarrageManager();

  List<BarrageModel> get barrages => barrageManager.bullets;

  void init(Size size) {
    if (isInit) return;
    isInit = true;
    _run();
  }

  void _run() => run(() {
        renderNextFrameRate(barrages, _allOutLeaveCallBack);
      }, setState);

  void run(Function nextFrame, Function setState) {
    _timer = Timer.periodic(Duration(milliseconds: BarrageConfig.unitTimer),
        (Timer timer) {
      // 弹幕暂停后就不执行
      if (!BarrageConfig.pause) {
        nextFrame();
        setState(() {});
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }

  // 子弹完全离开后回调
  void _allOutLeaveCallBack(UniqueKey bulletId) {
    // if (barrageManager.bulletsMap[bulletId]?.trackId != null) {
    //   _trackManager
    //       .removeTrackBindIdByBulletModel(_bulletManager.bulletsMap[bulletId]!);
    //   _bulletManager.bulletsMap.remove(bulletId);
    // }
  }

  // 渲染下一帧
  List<BarrageModel> renderNextFrameRate(
      List<BarrageModel> oldBarrages, Function(UniqueKey) allOutLeaveCallBack) {
    List<BarrageModel> newBarrages =
        List.generate(oldBarrages.length, (index) => oldBarrages[index]);
    for (var barrageModel in newBarrages) {
      barrageModel.runNextFrame();
      if (barrageModel.allOutLeave) {
        allOutLeaveCallBack(barrageModel.id);
      }
    }
    return newBarrages;
  }
}
