import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'barrage_config.dart';
import 'barrage_controller.dart';
import 'barrage_model.dart';

class BarrageView extends StatefulWidget {
  const BarrageView({Key? key, required this.controller}) : super(key: key);

  final BarrageController controller;

  @override
  State<BarrageView> createState() => _BarrageViewState();
}

class _BarrageViewState extends State<BarrageView> {
  late BarrageController controller;

  @override
  void initState() {
    super.initState();
    widget.controller.setState = setState;
    controller = widget.controller;
  }

  // 构建全部的子弹
  List<Widget> buildAllBullet(BuildContext context) {
    return List.generate(controller.barrages.length,
        (index) => buildBulletToScreen(context, controller.barrages[index]));
  }

  // 构建子弹
  Widget buildBulletToScreen(BuildContext context, BarrageModel barrageModel) {
    BarrageItem barrage = BarrageItem(
      barrageMode: barrageModel,
    );
    return Positioned(
      right: barrageModel.offsetX,
      top: barrageModel.offsetY,
      child: GestureDetector(
        onTap: () => BarrageConfig.bulletTapCallBack(barrageModel),
        child: barrage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [...buildAllBullet(context)],
    );
  }
}

class BarrageItem extends StatelessWidget {
  BarrageItem({Key? key, required this.barrageMode}) : super(key: key);
  BarrageModel barrageMode;

  /// 构建文字
  Widget buildText() {
    Text textWidget = Text(
      barrageMode.comment.commentContent ?? "",
      style: const TextStyle(
        fontSize: 14,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0x80FFFFFF),
      ),
      child: Row(
        children: [
          textWidget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildText(),
      ],
    );
  }
}
