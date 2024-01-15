import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/models/user_story.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_config.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_item.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_track.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_utils.dart';

import 'barrage_render_manager.dart';

enum AddBarrageResCode { success, noSpace }

class AddBarrageResBody {
  AddBarrageResCode code = AddBarrageResCode.success;
  String message;
  dynamic data;

  AddBarrageResBody(this.code, {this.message = '', this.data});
}

class BarrageController {
  BarrageTrackManager _trackManager = BarrageTrackManager();
  BarrageManager _bulletManager = BarrageManager();
  BarrageRenderManager _renderManager = BarrageRenderManager();

  List<BarrageTrack?> get tracks => _trackManager.tracks;

  List<BarrageModel> get bullets => _bulletManager.bullets;

  late Function setState;

  /// 是否暂停
  bool get isPause => BarrageConfig.pause;

  /// 是否初始化过
  bool get inited => _inited;
  bool _inited = false;

  /// 清除定时器
  void dispose() => _renderManager.dispose();

  // 成功返回AddBulletResBody.data为bulletId
  AddBarrageResBody addDanmaku(UserStoryComment text,
      {BarrageType barrageType = BarrageType.scroll,
      Color color = Colors.black,
      Widget Function(Text)? builder,
      int offsetMS = 0,
      BarragePosition position = BarragePosition.any}) {
    // 先获取子弹尺寸
    Size bulletSize =
        BarrageUtils.getDanmakuBulletSizeByText(text.commentContent ?? "");
    // 寻找可用的轨道
    BarrageTrack track = _findAvailableTrack(bulletSize,
        bulletType: barrageType, position: position, offsetMS: offsetMS);
    BarrageModel bullet = _bulletManager.initBullet(
        text, track.id, bulletSize, track.offsetTop,
        prevBulletId: track.lastBulletId,
        position: position,
        barrageType: barrageType,
        color: color,
        builder: builder,
        offsetMS: offsetMS);
    if (barrageType == BarrageType.scroll) {
      track.lastBulletId = bullet.id;
    } else {
      // 底部弹幕 不记录到轨道上
      // 查询是否可注入弹幕时 底部弹幕 和普通被注入到底部的静止弹幕可重叠
      if (position == BarragePosition.any) {
        track.loadFixedBulletId(bullet.id);
      }
    }
    return AddBarrageResBody(AddBarrageResCode.success, data: bullet.id);
  }

  void init(Size size) {
    resizeArea(size);
    _trackManager.buildTrackFullScreen();
    if (_inited) return;
    _inited = true;
    _run();
  }

  // 弹幕清屏
  void clearScreen() {
    _bulletManager.removeAllBullet();
    _trackManager.unloadAllBullet();
  }

  /// 暂停
  void pause() {
    BarrageConfig.pause = true;
  }

  /// 播放
  void play() {
    BarrageConfig.pause = false;
  }

  /// 修改弹幕速率
  void changeRate(double rate) {
    assert(rate > 0);
    BarrageConfig.bulletRate = rate;
  }

  /// 设置子弹单击事件
  void setBulletTapCallBack(Function(BarrageModel) cb) {
    BarrageConfig.bulletTapCallBack = cb;
  }

  /// 修改透明度
  void changeOpacity(double opacity) {
    assert(opacity <= 1);
    assert(opacity >= 0);
    BarrageConfig.opacity = opacity;
  }

  /// 修改文字大小
  void changeLableSize(int size) {
    assert(size > 0);
    BarrageConfig.bulletLableSize = size.toDouble();
    BarrageConfig.areaOfChildOffsetY = BarrageConfig.getAreaOfChildOffsetY();
    _trackManager.recountTrackOffset(_bulletManager.bulletsMap);
    _trackManager.resetBottomBullets(_bulletManager.bottomBullets,
        reSize: true);
  }

  /// 改变视图尺寸后调用，比如全屏
  void resizeArea(Size size) {
    BarrageConfig.areaSize = size;
    BarrageConfig.areaOfChildOffsetY = BarrageConfig.getAreaOfChildOffsetY();
    _trackManager.recountTrackOffset(_bulletManager.bulletsMap);
    _trackManager.resetBottomBullets(_bulletManager.bottomBullets);
    if (BarrageConfig.pause) {
      _renderManager.renderNextFrameRate(
          _bulletManager.bullets, _allOutLeaveCallBack);
    }
  }

  /// 修改弹幕最大可展示场景的百分比
  void changeShowArea(double percent) {
    assert(percent <= 1);
    assert(percent >= 0);
    BarrageConfig.showAreaPercent = percent;
    _trackManager.buildTrackFullScreen();
  }

  /// 请不要调用这个函数
  void delBulletById(UniqueKey bulletId) {
    _trackManager
        .removeTrackBindIdByBulletModel(_bulletManager.bulletsMap[bulletId]!);
    _bulletManager.removeBulletByKey(bulletId);
  }

  // 子弹完全离开后回调
  void _allOutLeaveCallBack(UniqueKey bulletId) {
    if (_bulletManager.bulletsMap[bulletId]?.trackId != null) {
      _trackManager
          .removeTrackBindIdByBulletModel(_bulletManager.bulletsMap[bulletId]!);
      _bulletManager.bulletsMap.remove(bulletId);
    }
  }

  void _run() => _renderManager.run(() {
        _renderManager.renderNextFrameRate(
            _bulletManager.bullets, _allOutLeaveCallBack);
      }, setState);

  /// 获取允许注入的轨道
  BarrageTrack _findAllowInsertTrack(Size bulletSize,
      {BarrageType bulletType = BarrageType.scroll, int offsetMS = 0}) {
    BarrageTrack track;
    // 在现有轨道里找
    for (int i = 0; i < tracks.length; i++) {
      // 当前轨道溢出可用轨道
      if (BarrageUtils.isEnableTrackOverflowArea(tracks[i]!)) break;
      bool allowInsert = _trackAllowInsert(tracks[i]!, bulletSize,
          bulletType: bulletType, offsetMS: offsetMS);
      if (allowInsert) {
        track = tracks[i];
        break;
      }
    }
    return track;
  }

  /// 查询该轨道是否允许注入
  bool _trackAllowInsert(BarrageTrack track, Size needInsertBulletSize,
      {BarrageType bulletType = BarrageType.scroll, int offsetMS = 0}) {
    UniqueKey? lastBulletId;
    assert(needInsertBulletSize.height > 0);
    assert(needInsertBulletSize.width > 0);
    // 非底部弹幕 超出配置的可视区域 就不可注入
    if (bulletType == BarrageType.fixed) return track.allowInsertFixedBullet;
    if (track.lastBulletId == null) return true;
    lastBulletId = track.lastBulletId;
    BarrageModel? lastBullet = _bulletManager.bulletsMap[lastBulletId];
    if (lastBullet == null) return true;
    return !BarrageUtils.trackInsertBulletHasBump(
        lastBullet, needInsertBulletSize,
        offsetMS: offsetMS);
  }

  // 查询可用轨道
  BarrageTrack _findAvailableTrack(Size bulletSize,
      {BarrageType bulletType = BarrageType.scroll,
      int offsetMS = 0,
      BarragePosition position = BarragePosition.any}) {
    assert(bulletSize.height > 0);
    assert(bulletSize.width > 0);
    return _findAllowInsertTrack(bulletSize,
        bulletType: bulletType, offsetMS: offsetMS);
  }
}
