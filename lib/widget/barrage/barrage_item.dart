import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_craft/models/user_story.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_config.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_track.dart';
import 'package:flutter_chat_craft/widget/barrage/barrage_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BarrageType { scroll, fixed }

enum BarragePosition { any, bottom }

class BarrageModel {
  UniqueKey id;
  UniqueKey trackId;
  UniqueKey? prevBulletId;
  Size bulletSize;
  String text;
  double offsetY;
  double _runDistance = 0;
  double everyFrameRunDistance;
  Color color = Colors.black;
  BarragePosition position = BarragePosition.any;

  Widget Function(Text)? builder;

  BarrageType barrageType;

  /// 子弹的x轴位置
  double get offsetX => barrageType == BarrageType.scroll
      ? _runDistance - bulletSize.width
      : BarrageConfig.areaSize.width / 2 - (bulletSize.width / 2);

  /// 子弹最大可跑距离 子弹宽度+墙宽度
  double get maxRunDistance => bulletSize.width + BarrageConfig.areaSize.width;

  /// 子弹整体脱离右边墙壁
  bool get allOutRight => _runDistance > bulletSize.width;

  /// 子弹整体离开屏幕
  bool get allOutLeave => _runDistance > maxRunDistance;

  /// 子弹当前执行的距离
  double get runDistance => _runDistance;

  /// 剩余离开的距离
  double get remainderDistance => needRunDistance - runDistance;

  /// 需要走的距离
  double get needRunDistance => BarrageConfig.areaSize.width + bulletSize.width;

  /// 离开屏幕剩余需要的时间
  double get leaveScreenRemainderTime =>
      remainderDistance / everyFrameRunDistance;

  /// 子弹执行下一帧
  void runNextFrame() {
    _runDistance += everyFrameRunDistance * BarrageConfig.bulletRate;
  }

  // 重新绑定轨道
  void rebindTrack(BarrageTrack track) {
    offsetY = track.offsetTop;
    trackId = track.id;
  }

  // 计算文字尺寸
  void completeSize() {
    bulletSize = BarrageUtils.getDanmakuBulletSizeByText(text);
  }

  BarrageModel({
    required this.id,
    required this.trackId,
    required this.text,
    required this.bulletSize,
    required this.offsetY,
    this.barrageType = BarrageType.scroll,
    required this.color,
    this.prevBulletId,
    required int offsetMS,
    this.builder,
    required this.position,
    this.everyFrameRunDistance = 0,
  }) {
    everyFrameRunDistance =
        BarrageUtils.getBulletEveryFrameRateRunDistance(bulletSize.width);
    _runDistance = offsetMS != null
        ? (offsetMS / BarrageConfig.unitTimer) * everyFrameRunDistance
        : 0;
  }
}

class BarrageManager {
  Map<UniqueKey, BarrageModel> _bullets = {};

  List<BarrageModel> get bullets => _bullets.values.toList();

  // 返回所有的底部弹幕
  List<BarrageModel> get bottomBullets => bullets
      .where((element) => element.position == BarragePosition.bottom)
      .toList();

  List<UniqueKey> get bulletKeys => _bullets.keys.toList();

  Map<UniqueKey, BarrageModel> get bulletsMap => _bullets;

  // 记录子弹到map中
  recordBullet(BarrageModel bullet) {
    _bullets[bullet.id] = bullet;
  }

  void removeBulletByKey(UniqueKey id) => _bullets.remove(id);

  void removeAllBullet() {
    _bullets = {};
  }

  // 初始化一个子弹
  BarrageModel initBullet(
      String text, UniqueKey trackId, Size bulletSize, double offsetY,
      {BarrageType barrageType = BarrageType.scroll,
      BarragePosition position = BarragePosition.any,
      Color color = Colors.black,
      UniqueKey? prevBulletId,
      int offsetMS = 0,
      Widget Function(Text)? builder}) {
    assert(bulletSize.height > 0);
    assert(bulletSize.width > 0);
    assert(offsetY >= 0);
    UniqueKey bulletId = UniqueKey();
    BarrageModel bullet = BarrageModel(
        color: color,
        id: bulletId,
        trackId: trackId,
        text: text,
        position: position,
        bulletSize: bulletSize,
        offsetY: offsetY,
        offsetMS: offsetMS,
        prevBulletId: prevBulletId,
        barrageType: barrageType,
        builder: builder);
    // 记录到表上
    recordBullet(bullet);
    return bullet;
  }
}

class BarrageItem extends StatelessWidget {
  BarrageItem(
    this.danmakuId,
    this.text, {
    this.color = Colors.black,
    this.builder,
    this.key,
  });

  String text;
  UniqueKey danmakuId;
  Color color;

  Widget Function(Text)? builder;

  GlobalKey? key;

  /// 构建文字
  Widget buildText() {
    Text textWidget = Text(
      text,
      style: TextStyle(
        fontSize: BarrageConfig.bulletLableSize,
        color: color.withOpacity(BarrageConfig.opacity),
      ),
    );
    if (builder != null) {
      return builder!(textWidget);
    }
    return textWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Solid text as fill.
        buildText()
      ],
    );
  }
}
