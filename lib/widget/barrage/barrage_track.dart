import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_config.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_item.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_utils.dart';

class BarrageTrack {
  UniqueKey id = UniqueKey();

  UniqueKey? lastBulletId;

  UniqueKey? _bindFixedBulletId; // 绑定的静止定位弹幕ID

  UniqueKey? get bindFixedBulletId => _bindFixedBulletId;

  BarrageTrack(this.trackHeight, this.offsetTop);

  double offsetTop;

  double trackHeight;

  // 允许注入静止弹幕
  bool get allowInsertFixedBullet => bindFixedBulletId == null;

  // 卸载静止定位的子弹
  void unloadFixedBulletId() {
    _bindFixedBulletId = null;
  }

  void unloadLastBulletId() {
    lastBulletId = null;
  }

  void loadFixedBulletId(UniqueKey bulletId) {
    _bindFixedBulletId = bulletId;
  }
}

class BarrageTrackManager {
  List<BarrageTrack?> tracks = [];

  double get allTrackHeight {
    if (tracks.isEmpty) return 0;
    return tracks.last!.offsetTop + tracks.last!.trackHeight;
  }

  // 剩余可用高度
  double get remainderHeight => BarrageConfig.showAreaHeight - allTrackHeight;

  // 算轨道相对区域是否溢出
  bool get isTrackOverflowArea =>
      allTrackHeight > BarrageConfig.areaSize.height;

  BarrageTrack buildTrack(double trackHeight) {
    assert(trackHeight > 0);
    BarrageTrack track = BarrageTrack(trackHeight, allTrackHeight);
    tracks.add(track);
    return track;
  }

  // 补足屏幕内轨道
  void buildTrackFullScreen() {
    Size singleTextSize = BarrageUtils.getDanmakuBulletSizeByText('s');
    while (allTrackHeight <
        (BarrageConfig.areaSize.height - singleTextSize.height)) {
      buildTrack(singleTextSize.height);
    }
  }

  // 重新计算轨道高度和距顶
  void recountTrackOffset(Map<UniqueKey, BarrageModel> bulletMap) {
    bool needBuildTrackFullScreen = true;
    Size currentLabelSize = BarrageUtils.getDanmakuBulletSizeByText('s');
    for (int i = 0; i < tracks.length; i++) {
      tracks[i]?.trackHeight = currentLabelSize.height;
      tracks[i]?.offsetTop = currentLabelSize.height * i;
      resetBullletsByTrack(tracks[i]!, bulletMap);
      // 把溢出可用区域的轨道之后全部删掉
      if ((tracks[i]!.trackHeight + tracks[i]!.offsetTop) >
          BarrageConfig.areaSize.height) {
        for (int j = tracks.length - 1; j >= i; j--) {
          delBullletsByTrack(tracks[j]!, bulletMap);
        }
        tracks.removeRange(i, tracks.length);
        needBuildTrackFullScreen = false;
        break;
      }
    }
    if (needBuildTrackFullScreen) buildTrackFullScreen();
  }

  // 删除轨道上的所有子弹
  void delBullletsByTrack(
      BarrageTrack track, Map<UniqueKey, BarrageModel> bulletMap) {
    if (track.bindFixedBulletId != null)
      bulletMap.remove(track.bindFixedBulletId);
    UniqueKey? prevBulletId = track.lastBulletId;
    while (prevBulletId != null) {
      UniqueKey? _prevBulletId = bulletMap[prevBulletId]?.prevBulletId;
      bulletMap.remove(prevBulletId);
      prevBulletId = _prevBulletId;
    }
  }

  // 重设轨道上的所有子弹
  void resetBullletsByTrack(
      BarrageTrack track, Map<UniqueKey, BarrageModel> bulletMap) {
    if (track.bindFixedBulletId != null) {
      if (bulletMap[track.bindFixedBulletId] == null) return;
      bulletMap[track.bindFixedBulletId]?.offsetY = track.offsetTop;
      Size newBulletSize = BarrageUtils.getDanmakuBulletSizeByText(
          bulletMap[track.bindFixedBulletId]!.text);
      bulletMap[track.bindFixedBulletId]?.bulletSize = newBulletSize;
    }
    UniqueKey? prevBulletId = track.lastBulletId;
    while (prevBulletId != null) {
      UniqueKey? _prevBulletId = bulletMap[prevBulletId]?.prevBulletId;
      if (bulletMap[prevBulletId] == null) return;
      bulletMap[prevBulletId]?.offsetY = track.offsetTop;
      bulletMap[prevBulletId]?.completeSize();
      prevBulletId = _prevBulletId;
    }
  }

  // 重置底部弹幕位置
  void resetBottomBullets(List<BarrageModel> bottomBullets,
      {bool reSize = false}) {
    if (bottomBullets.isEmpty) return;
    for (int i = 0; i < bottomBullets.length; i++) {
      bottomBullets[i].rebindTrack(tracks[tracks.length - 1 - i]!);
      if (reSize) bottomBullets[i].completeSize();
    }
  }

  // 是否允许建立新轨道
  bool areaAllowBuildNewTrack(double needBuildTrackHeight) {
    assert(needBuildTrackHeight > 0);
    if (tracks.isEmpty) return true;
    return remainderHeight >= needBuildTrackHeight;
  }

  /// 删除轨道上绑定的子弹ID
  void removeTrackBindIdByBulletModel(BarrageModel bulletModel) {
    // 底部弹幕并没有绑定到轨道上
    if (bulletModel.position == BarragePosition.bottom) return;
    if (bulletModel.barrageType == BarrageType.scroll) {
      tracks
          .firstWhere((element) => element?.lastBulletId == bulletModel.id,
              orElse: () => null)
          ?.unloadLastBulletId();
    } else if (bulletModel.barrageType == BarrageType.fixed) {
      tracks
          .firstWhere((element) => element?.bindFixedBulletId == bulletModel.id,
              orElse: () => null)
          ?.unloadFixedBulletId();
    }
  }

  // 卸载全部轨道上绑定的弹幕ID
  unloadAllBullet() {
    for (var track in tracks) {
      track?.unloadFixedBulletId();
      track?.unloadLastBulletId();
    }
  }
}
