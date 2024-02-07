import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageCustomPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

class MessageCustomPopupMenu extends StatefulWidget {
  const MessageCustomPopupMenu({
    Key? key,
    required this.child,
    this.controller,
    required this.menuWidget,
  }) : super(key: key);

  final Widget child;
  final MessageCustomPopupMenuController? controller;
  final Widget menuWidget;

  @override
  State<MessageCustomPopupMenu> createState() => _MessageCustomPopupMenuState();
}

class _MessageCustomPopupMenuState extends State<MessageCustomPopupMenu> {
  MessageCustomPopupMenuController? _controller;
  OverlayEntry? _overlayEntry;
  RenderBox? _parentBox;
  LongPressStartDetails? _longPressStartDetails;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller ??= MessageCustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      _parentBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  _updateView() {
    if (_controller?.menuIsShowing ?? false) {
      _showMenu(context, _longPressStartDetails!);
    } else {
      _hideMenu();
    }
  }

  /// 显示浮层
  void _showMenu(BuildContext context, LongPressStartDetails details) {
    /// 防止重复创建，不然失去句柄的OverlayEntry将无法消除
    if (_overlayEntry == null) {
      // if (details.globalPosition.dx + 120.w > 1.sw) {}
      // final Offset overlayOffset =
      //     Offset(details.globalPosition.dx, details.globalPosition.dy);
      _overlayEntry = _createOverlayEntry();
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    if (_longPressStartDetails != null) {
      _longPressStartDetails = null;
    }
  }

  /// 创建浮层
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _hideMenu();
          },
          child: UnconstrainedBox(
            child: CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.centerRight,
              followerAnchor: Alignment.bottomCenter,
              offset: const Offset(50, 20),
              child: Material(
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(0, 3),
                          blurRadius: 8,
                        )
                      ]),
                  child: widget.menuWidget,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (details) => _hideMenu(),
      onLongPressStart: (details) => _showMenu(context, details),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.child,
      ),
    );
  }
}
