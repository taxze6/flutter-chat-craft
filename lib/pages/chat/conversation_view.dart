import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/chat/conversation_logic.dart';
import 'package:flutter_chat_craft/res/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../res/images.dart';
import 'widget/appbar_title.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final conversationLogic = Get.find<ConversationLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              ImagesRes.icSearch,
            ),
          )
        ],
      ),
    );
  }
}
