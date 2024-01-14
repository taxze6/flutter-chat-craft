import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_config.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_item.dart';

class BarrageRenderManager {
  Timer? _timer;

  Timer? get timer => _timer;

  void run(Function nextFrame, Function setState) {
    _timer = Timer.periodic(Duration(milliseconds: BarrageConfig.unitTimer),
        (Timer timer) {
      // 暂停不执行
      if (!BarrageConfig.pause) {
        nextFrame();
        setState(() {});
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }

  // 渲染下一帧
  List<BarrageModel> renderNextFramerate(
      List<BarrageModel> bullets, Function(UniqueKey) allOutLeaveCallBack) {
    List<BarrageModel> _bullets =
        List.generate(bullets.length, (index) => bullets[index]);
    _bullets.forEach((BarrageModel bulletModel) {
      bulletModel.runNextFrame();
      if (bulletModel.allOutLeave) {
        allOutLeaveCallBack(bulletModel.id);
      }
    });
    return _bullets;
  }
}
