import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/chat/new_chat/new_chat_logic.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../models/contact.dart';
import '../../../widget/my_appbar.dart';
import 'package:collection/collection.dart';

import 'widget/new_chat_cursor.dart';
import 'widget/new_chat_index_bar.dart';
import 'widget/new_chat_item.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final newChatLogic = Get.find<NewChatLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: StrRes.newChat,
        color: Colors.white,
        backColor: const Color(0xFFFFC15E),
        backOnTap: () => Get.back(),
      ),
      body: Stack(children: [
        Positioned(
          top: 0,
          child: topBack(),
        ),
        SliverViewObserver(
          controller: newChatLogic.observerController,
          sliverContexts: () {
            return newChatLogic.sliverContextMap.values.toList();
          },
          child: CustomScrollView(
            key: ValueKey(newChatLogic.isShowListMode),
            controller: newChatLogic.scrollController,
            slivers: newChatLogic.contactList.mapIndexed((i, e) {
              return _buildSliver(index: i, model: e);
            }).toList(),
          ),
        ),
        _buildCursor(),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: _buildIndexBar(),
        ),
        // AzListPage(),
      ]),
    );
  }

  Widget topBack() {
    return Container(
      width: 1.sw,
      height: 88.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFFC15E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(42.w),
          bottomRight: Radius.circular(42.w),
        ),
      ),
    );
  }

  Widget _buildCursor() {
    return ValueListenableBuilder<CursorInfoModel?>(
      valueListenable: newChatLogic.cursorInfo,
      builder: (
        BuildContext context,
        CursorInfoModel? value,
        Widget? child,
      ) {
        Widget resultWidget = Container();
        double top = 0;
        double right = newChatLogic.indexBarWidth + 8;
        if (value == null) {
          resultWidget = const SizedBox.shrink();
        } else {
          double titleSize = 80;
          top = value.offset.dy - titleSize * 0.5;
          resultWidget = NewChatCursor(size: titleSize, title: value.title);
        }
        resultWidget = Positioned(
          top: top,
          right: right,
          child: resultWidget,
        );
        return resultWidget;
      },
    );
  }

  Widget _buildIndexBar() {
    return Container(
      key: newChatLogic.indexBarContainerKey,
      width: newChatLogic.indexBarWidth,
      alignment: Alignment.center,
      child: NewChatIndexBar(
        parentKey: newChatLogic.indexBarContainerKey,
        symbols: newChatLogic.symbols,
        onSelectionUpdate: (index, cursorOffset) {
          newChatLogic.cursorInfo.value = CursorInfoModel(
            title: newChatLogic.symbols[index],
            offset: cursorOffset,
          );
          final sliverContext = newChatLogic.sliverContextMap[index];
          if (sliverContext == null) return;
          newChatLogic.observerController.jumpTo(
            index: 0,
            sliverContext: sliverContext,
          );
        },
        onSelectionEnd: () {
          newChatLogic.cursorInfo.value = null;
        },
      ),
    );
  }

  Widget _buildSliver({
    required int index,
    required ContactModel model,
  }) {
    final users = model.users;
    if (users.isEmpty) return const SliverToBoxAdapter();
    Widget resultWidget = newChatLogic.isShowListMode
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, itemIndex) {
                if (newChatLogic.sliverContextMap[index] == null) {
                  newChatLogic.sliverContextMap[index] = context;
                }
                return NewChatItem(user: users[itemIndex]);
              },
              childCount: users.length,
            ),
          )
        : SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Grid按两列显示
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int itemIndex) {
                if (newChatLogic.sliverContextMap[index] == null) {
                  newChatLogic.sliverContextMap[index] = context;
                }
                return NewChatItem(user: users[itemIndex]);
              },
              childCount: users.length,
            ),
          );
    resultWidget = SliverStickyHeader(
      header: Container(
        height: 44.0,
        color: const Color.fromARGB(255, 243, 244, 246),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          model.section,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      sliver: resultWidget,
    );
    return resultWidget;
  }
}
