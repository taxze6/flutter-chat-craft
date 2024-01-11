import 'package:flutter/material.dart';

enum TransitionDirection { ltr, rtl, ttb, btt }

class BarrageTransition extends StatefulWidget {
  const BarrageTransition({
    Key? key,
    required this.child,
    required this.duration,
    required this.direction,
    required this.onComplete,
  }) : super(key: key);
  final Widget child;

  final Duration duration;

  final TransitionDirection direction;
  final ValueChanged onComplete;

  @override
  State<BarrageTransition> createState() => _BarrageTransitionState();
}

class _BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: widget.duration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete('');
            }
          });
    var begin = const Offset(-1.0, .0);
    var end = const Offset(1.0, .0);
    switch (widget.direction) {
      case TransitionDirection.ltr:
        begin = const Offset(-1.0, .0);
        end = const Offset(1.0, .0);
        break;
      case TransitionDirection.rtl:
        begin = const Offset(1.0, .0);
        end = const Offset(-1.0, .0);
        break;
      case TransitionDirection.ttb:
        begin = const Offset(.0, .0);
        end = const Offset(.0, 2.0);
        break;
      case TransitionDirection.btt:
        begin = const Offset(.0, 2.0);
        end = const Offset(.0, .0);
        break;
    }
    _animation = Tween(begin: begin, end: end).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
