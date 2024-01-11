// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
//
// import 'barrage_transition.dart';
//
// const Duration _kDuration = Duration(seconds: 10);
//
// class BarrageView extends StatefulWidget {
//   const BarrageView(
//       {Key? key,
//       required this.showCount,
//       required this.padding,
//       required this.randomOffset})
//       : super(key: key);
//
//   /// 显示的行数
//   final int showCount;
//
//   /// 水平弹幕：表示top、bottom的padding
//   /// 垂直弹幕：表示left、right的padding
//   final double padding;
//
//   /// 随机偏移量
//   final int randomOffset;
//
//   @override
//   State<BarrageView> createState() => _BarrageViewState();
// }
//
// class _BarrageViewState extends State<BarrageView> {
//   List<_BarrageTransitionItem> _barrageList = [];
//
//   ///
//   /// 定时清除弹幕
//   ///
//   late Timer _timer;
//   Random _random = Random();
//   double _height = 0;
//   double _width = 0;
//   int barrageIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraintType) {
//         _height = constraintType.maxHeight;
//         _width = constraintType.maxWidth;
//
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(0),
//           child: Stack(
//             children: []..addAll(_barrageList),
//           ),
//         );
//       },
//     );
//   }
//
//   addBarrage(Widget child, {Duration duration = _kDuration}) {
//     double perRowHeight = (_height - 2 * widget.padding) / widget.showCount;
//     //计算距离顶部的偏移，
//     // 不直接使用_barrageList.length的原因：弹幕结束会删除列表中此项，如果
//     // 此时正好有一个弹幕来，会造成此弹幕和上一个弹幕同行
//     var index = 0;
//     if (_barrageList.length == 0) {
//       //屏幕中没有弹幕，从顶部开始
//       index = 0;
//       barrageIndex++;
//     } else {
//       index = barrageIndex++;
//     }
//     var top = _computeTop(index, perRowHeight);
//     if (barrageIndex > 100000) {
//       //避免弹幕数量一直累加超过int的最大值
//       barrageIndex = 0;
//     }
//     var bottom = _height - top - perRowHeight;
//     //给每一项生成一个唯一id，用于删除
//     String id = '${DateTime.now().toIso8601String()}:${_random.nextInt(1000)}';
//     var item = _BarrageTransitionItem(
//       id: id,
//       top: top,
//       bottom: bottom,
//       child: child,
//       onComplete: _onComplete,
//       duration: duration,
//     );
//     _barrageList.add(item);
//     setState(() {});
//   }
// }
//
// class _BarrageTransitionItem extends StatelessWidget {
//   _BarrageTransitionItem(
//       {required this.id,
//       required this.top,
//       required this.bottom,
//       required this.child,
//       required this.onComplete,
//       required this.duration});
//
//   final String id;
//   final double top;
//   final double bottom;
//   final Widget child;
//   final ValueChanged onComplete;
//   final Duration duration;
//
//   // var _key = GlobalKey<BarrageTransitionState>();
//
//   // bool get isComplete => _key.currentState.isComplete;
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       top: top,
//       bottom: bottom,
//       child: BarrageTransition(
//         key: _key,
//         child: child,
//         onComplete: (v) {
//           onComplete(id);
//         },
//         duration: duration,
//       ),
//     );
//   }
// }
