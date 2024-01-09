import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/pages/chat/new_chat/new_chat_logic.dart';
import 'package:get/get.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final newChatLogic = Get.find<NewChatLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
