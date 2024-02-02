import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTypingWidget extends StatefulWidget {
  const ChatTypingWidget({Key? key}) : super(key: key);

  @override
  State<ChatTypingWidget> createState() => _ChatTypingWidgetState();
}

class _ChatTypingWidgetState extends State<ChatTypingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _repaintAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1999),
    );
    _repaintAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.forward();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.w),
      constraints: BoxConstraints(maxWidth: 0.3.sw),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _repaintAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: TypingPainter(_repaintAnimation),
              size: Size(30.w, 20.w),
            );
          },
        ),
      ),
    );
  }
}

class TypingPainter extends CustomPainter {
  final Animation<double> repaint;
  List xAliax = [];

  TypingPainter(this.repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // 获取采样点
    initPoints();
    // 画笔
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    // 路径
    Path path = Path();
    canvas.translate(-25.w, size.height / 2);
    // 通过点确定曲线路径
    for (var i = 1; i < xAliax.length - 1; i++) {
      double x1 = xAliax[i];
      double y1 = funcSquaredSinx(x1);
      double x2 = (xAliax[i] + xAliax[i + 1]) / 2;
      double y2 = (y1 + funcSquaredSinx(xAliax[i + 1])) / 2;
      path.quadraticBezierTo(x1, y1, x2, y2);
    }
    // 画布绘制
    canvas.drawPath(path, paint);
  }

  void initPoints() {
    // 定义采样点的范围和间隔
    double start = 0;
    double end = 85.w; // 根据您的需求进行调整
    double step = 5; // 根据您的需求进行调整

    // 生成采样点
    for (double x = start; x <= end; x += step) {
      xAliax.add(x);
    }
  }

  //曲线函数表达式
  double funcSquaredSinx(double x) {
    double p =
        10 * sin(3 * pi * x / 200 - 100 * repaint.value) * sin(x * pi / 100);
    return p;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
