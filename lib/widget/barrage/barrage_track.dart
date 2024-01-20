import 'package:flutter/material.dart';

import 'barrage_config.dart';
import 'barrage_model.dart';
import 'barrage_utils.dart';

class BarrageTrack {
  UniqueKey id = UniqueKey();
  UniqueKey? lastBulletId;
  double offsetTop;
  double trackHeight;

  BarrageTrack(
    this.offsetTop,
    this.trackHeight,
  );

  void unloadLastBulletId() {
    lastBulletId = null;
  }

  @override
  String toString() {
    return 'BarrageTrack(id: $id, lastBulletId: $lastBulletId, offsetTop: $offsetTop, trackHeight: $trackHeight)';
  }
}

class BarrageTrackManager {
  List<BarrageTrack> tracks = [];

  double get allTrackHeight {
    if (tracks.isEmpty) return 0;
    return tracks.last.offsetTop + tracks.last.trackHeight;
  }

  // 剩余可用高度
  double get remainderHeight => BarrageConfig.areaSize.height - allTrackHeight;

  // 算轨道相对区域是否溢出
  bool get isTrackOverflowArea =>
      allTrackHeight > BarrageConfig.areaSize.height;

  BarrageTrack buildTrack(double trackHeight) {
    assert(trackHeight > 0);
    BarrageTrack track = BarrageTrack(allTrackHeight, trackHeight);
    print(track.toString());
    tracks.add(track);
    return track;
  }

  // 补足屏幕内轨道
  void buildTrackFullScreen() {
    //预估的轨道高度
    Size singleTextSize = BarrageUtils.getDanmakuBulletSizeByText('s');
    while (allTrackHeight <
        (BarrageConfig.areaSize.height - singleTextSize.height)) {
      if (areaAllowBuildNewTrack(singleTextSize.height)) {
        buildTrack(singleTextSize.height);
      }
    }
  }

  // 是否允许建立新轨道
  bool areaAllowBuildNewTrack(double needBuildTrackHeight) {
    assert(needBuildTrackHeight > 0);
    if (tracks.isEmpty) return true;
    return remainderHeight >= needBuildTrackHeight;
  }

  /// 删除轨道上绑定的弹幕ID
  void removeTrackBindIdByBulletModel(BarrageModel barrageModel) {
    tracks.firstWhere((element) => element.lastBulletId == barrageModel.id);
  }
}
