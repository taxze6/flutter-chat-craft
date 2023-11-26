import 'package:flutter/material.dart';

/// Touch to close the keyboard.
class TouchCloseSoftKeyboard extends StatelessWidget {
  final Widget child;
  final Function? onTouch;

  const TouchCloseSoftKeyboard({
    Key? key,
    required this.child,
    this.onTouch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onTouch?.call();
      },
      child: child,
    );
  }
}
