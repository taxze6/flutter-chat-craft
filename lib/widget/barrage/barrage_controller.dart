import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/user_story.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_track.dart';

import 'barrage_config.dart';
import 'barrage_model.dart';
import 'barrage_utils.dart';

class BarrageController {
  late Function setState;

  /// 是否暂停
  bool get isPause => BarrageConfig.pause;

  /// 是否初始化过
  bool isInit = false;

  /// 弹幕定时器
  Timer? _timer;
  BarrageManager barrageManager = BarrageManager();
  BarrageTrackManager trackManager = BarrageTrackManager();

  List<BarrageModel> get barrages => barrageManager.bullets;

  List<BarrageTrack> get tracks => trackManager.tracks;

  void init(Size size) {
    resizeArea(size);
    trackManager.buildTrackFullScreen();
    if (isInit) return;
    isInit = true;
    _run();
  }

  void _run() => run(() {
        renderNextFrameRate(barrages, allOutLeaveCallBack);
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

  /// 暂停
  void pause() {
    BarrageConfig.pause = true;
  }

  /// 播放
  void play() {
    BarrageConfig.pause = false;
  }

  void dispose() {
    _timer?.cancel();
  }

  // 弹幕清屏
  void clearScreen() {
    barrageManager.removeAllBarrage();
  }

  /// 改变视图尺寸后调用，比如全屏
  void resizeArea(Size size) {
    BarrageConfig.areaSize = size;
  }

  BarrageModel addBarrage(
    UserStoryComment comment,
  ) {
    Size barrageSize =
        BarrageUtils.getDanmakuBulletSizeByText(comment.commentContent ?? "");
    double everyFrameRunDistance =
        BarrageUtils.getBulletEveryFrameRateRunDistance(barrageSize.width);
    double runDistance = BarrageConfig.unitTimer * everyFrameRunDistance;
    BarrageTrack track = findAllowInsertTrack(barrageSize)!;
    double offsetY = track.offsetTop;
    BarrageModel barrage = barrageManager.initBarrage(
      comment: comment,
      offsetY: offsetY,
      everyFrameRunDistance: everyFrameRunDistance,
      runDistance: runDistance,
      barrageSize: barrageSize,
    );
    track.lastBulletId = barrage.id;
    print("加入的轨道为：${track.toString()}");
    return barrage;
  }

  /// 设置子弹单击事件
  void setBulletTapCallBack(Function(BarrageModel) callBack) {
    BarrageConfig.bulletTapCallBack = callBack;
  }

  // 子弹完全离开后回调
  void allOutLeaveCallBack(UniqueKey bulletId) {
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

  BarrageTrack? findAllowInsertTrack(Size barrageSize) {
    BarrageTrack? track;
    // 在现有轨道里找
    for (int i = 0; i < tracks.length; i++) {
      // 当前轨道溢出可用轨道
      if (BarrageUtils.isEnableTrackOverflowArea(tracks[i])) break;
      bool allowInsert = _trackAllowInsert(tracks[i], barrageSize);
      if (allowInsert) {
        track = tracks[i];
        break;
      }
    }
    return track;
  }

  /// 查询该轨道是否允许注入
  bool _trackAllowInsert(BarrageTrack track, Size needInsertBulletSize) {
    UniqueKey? lastBulletId;
    assert(needInsertBulletSize.height > 0);
    assert(needInsertBulletSize.width > 0);
    if (track.lastBulletId == null) return true;
    lastBulletId = track.lastBulletId;
    BarrageModel? lastBarrage = barrageManager.barragesMap[lastBulletId];
    if (lastBarrage == null) return true;
    return !BarrageUtils.trackInsertBulletHasBump(
      lastBarrage,
      needInsertBulletSize,
    );
  }
}
