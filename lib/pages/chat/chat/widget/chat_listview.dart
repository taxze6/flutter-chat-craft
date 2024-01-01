import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_craft/res/styles.dart';
import 'package:flutter_chat_craft/utils/touch_close_keyboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widget/expanded_viewport.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    this.onTouch,
    this.onScrollDownLoad,
    this.onScrollUpLoad,
    this.itemCount,
    this.controller,
    required this.itemBuilder,
    this.enabledScrollUpLoad = false,
  }) : super(key: key);
  final Function()? onTouch;
  final int? itemCount;
  final ScrollController? controller;
  final IndexedWidgetBuilder itemBuilder;

  /// Scroll down to load more messages and retrieve historical messages.
  final Future<bool> Function()? onScrollDownLoad;

  /// Enable upward scrolling to load more messages, which is useful for locating specific messages while searching.
  final Future<bool> Function()? onScrollUpLoad;

  /// Enable infinite scroll for loading previous messages, which is useful for locating specific messages while searching.
  final bool enabledScrollUpLoad;

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  var _scrollDownLoadMore = true;
  var _scrollUpLoadMore = true;

  bool _fillFirstPage() => true;

  @override
  void initState() {
    _onScrollDownLoadMore();
    widget.controller?.addListener(() {
      var max = widget.controller!.position.maxScrollExtent;
      if (_isBottom && _fillFirstPage()) {
        print('-------------ChatListView scroll to bottom');
        _onScrollDownLoadMore();
      } else if (_isTop && widget.enabledScrollUpLoad) {
        _onScrollUpLoadMore();
        print('-------------ChatListView scroll to top');
      }
    });
    super.initState();
  }

  bool get _isBottom =>
      widget.controller!.offset >= widget.controller!.position.maxScrollExtent;

  bool get _isTop => widget.controller!.offset <= 0;

  void _onScrollDownLoadMore() {
    widget.onScrollDownLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollDownLoadMore = hasMore;
      });
    });
  }

  void _onScrollUpLoadMore() {
    widget.onScrollUpLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollUpLoadMore = hasMore;
      });
    });
  }

  Widget _buildLoadMoreView() => SizedBox(
        height: 20.h,
        child: const CupertinoActivityIndicator(
          color: PageStyle.chatColor,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Align(
        alignment: Alignment.topCenter,
        // child:
        // Padding(
        //   padding: EdgeInsets.only(top: 10.h, left: 18.w, right: 18.w),
          // child: Scrollable(
          //   controller: widget.controller,
          //   axisDirection: AxisDirection.up,
          //   physics: const ScrollPhysics (),
          //   viewportBuilder: (BuildContext context, ViewportOffset position) {
          //     return ExpandedViewport(
          //       offset: position,
          //       axisDirection: AxisDirection.up,
          //       slivers: [
          //         SliverExpanded(),
          //         SliverList(
          //           delegate: SliverChildBuilderDelegate(
          //             childCount: widget.itemCount ?? 0,
          //             (BuildContext context, int index) {
          //               return _wrapItem(index);
          //             },
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          // ),
          // child: CustomScrollView(
          //   controller: widget.controller,
          //   reverse: true,
          //   // center: centerKey,
          //   slivers: [
          //     SliverList(
          //         delegate: SliverChildBuilderDelegate(
          //             childCount: widget.itemCount ?? 0,
          //             (BuildContext context, int index) {
          //       return _wrapItem(index);
          //     }))
          //   ],
          // ),
        // ),
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: widget.itemCount ?? 0,
          padding: EdgeInsets.only(top: 10.h, left: 18.w, right: 18.w),
          controller: widget.controller,
          dragStartBehavior: DragStartBehavior.down,
          itemBuilder: (context, index) {
            return _wrapItem(index);
          },
        ),
      ),
    );
  }

  Widget _wrapItem(int index) {
    Widget? loadView;
    final child = widget.itemBuilder(context, index);
    if (index == widget.itemCount! - 1) {
      if (_scrollDownLoadMore) {
        loadView = _buildLoadMoreView();
      } else {
        loadView = const SizedBox(); // No more updates available.
      }
      return Column(children: [loadView, child]);
    }
    if (index == 0 && widget.enabledScrollUpLoad) {
      if (_scrollUpLoadMore) {
        loadView = _buildLoadMoreView();
      } else {
        loadView = const SizedBox(); // No more updates available.
      }
      return Column(children: [child, loadView]);
    }
    return child;
  }
}
