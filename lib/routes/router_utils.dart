import 'package:flutter/material.dart';

//Scale Route Animation
class ScaleRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  ScaleRouter({required this.child, this.durationMs = 500,this.curve=Curves.fastOutSlowIn})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: Duration(milliseconds: durationMs),
    transitionsBuilder: (context, a1, a2, child) =>
        ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: a1, curve: curve)),
          child: child,
        ),
  );
}
//Gradient Transparent Routing Animation
class FadeRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  FadeRouter({required this.child, this.durationMs = 500,this.curve=Curves.fastOutSlowIn})
      : super(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: durationMs),
      transitionsBuilder: (context, a1, a2, child) =>
          FadeTransition(
            opacity: Tween(begin: 0.1, end: 1.0).animate(
                CurvedAnimation(parent: a1, curve:curve,)),
            child: child,
          ));
}

//旋转路由动画
class RotateRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  RotateRouter({required this.child, this.durationMs = 500,this.curve=Curves.fastOutSlowIn})
      : super(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: durationMs),
      transitionsBuilder: (context, a1, a2, child) =>
          RotationTransition(
            turns: Tween(begin: 0.1, end: 1.0).animate(
                CurvedAnimation(parent: a1, curve:curve,)),
            child: child,
          ));
}

//Right to Left
class Right2LeftRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Right2LeftRouter({required this.child,this.durationMs=500,this.curve=Curves.fastOutSlowIn})
      :super(
      transitionDuration:Duration(milliseconds: durationMs),
      pageBuilder:(ctx,a1,a2)=>child,
      transitionsBuilder:(ctx,a1,a2, child,) =>
         SlideTransition(
           child: child,
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0),).animate(
                CurvedAnimation(parent: a1, curve: curve)),
        ));
}

//Left to Right
class Left2RightRouter extends PageRouteBuilder {
  final Widget child;
  Left2RightRouter({required this.child})
      : super(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      child,
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
          SlideTransition(
            position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0), end: Offset.zero)
                .animate(animation),
            child: child,
          ));
}

//Top to Bottom
class Top2BottomRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Top2BottomRouter({required this.child,this.durationMs=500,this.curve=Curves.fastOutSlowIn})
      :super(
      transitionDuration:Duration(milliseconds: durationMs),
      pageBuilder:(ctx,a1,a2){return child;},
      transitionsBuilder:(ctx,a1,a2, child,) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0,-1.0), end: const Offset(0.0, 0.0),).animate(
                CurvedAnimation(parent: a1, curve: curve)),
            child:  child
        );
      });
}

//Bottom to Top
class Bottom2TopRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Bottom2TopRouter({required this.child,this.durationMs=500,this.curve=Curves.fastOutSlowIn})
      :super(
      transitionDuration:Duration(milliseconds: durationMs),
      pageBuilder:(ctx,a1,a2)=> child,
      transitionsBuilder:(ctx,a1,a2, child,) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0),).animate(
                CurvedAnimation(parent: a1, curve: curve)),
            child:  child
        );
      });
}

//Scale + Transparency + Rotation Routing Animation
class ScaleFadeRotateRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  ScaleFadeRotateRouter({required this.child, this.durationMs = 1000,this.curve=Curves.fastOutSlowIn}) : super(
      transitionDuration: Duration(milliseconds: durationMs),
      pageBuilder: (ctx, a1, a2)=>child,//页面
      transitionsBuilder: (ctx, a1, a2, Widget child,) =>
          RotationTransition(//旋转动画
          turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: a1,
            curve: curve,
          )),
            child: ScaleTransition(//缩放动画
            scale: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: a1, curve: curve)),
            child: FadeTransition(opacity://透明度动画
            Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: a1, curve: curve)),
              child: child,),
          ),
        ));
}
//No AnimRouter
class NoAnimRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  NoAnimRouter({required this.child})
      : super(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: const Duration(milliseconds: 0),
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) => child);
}
