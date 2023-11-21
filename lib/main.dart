import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/app.dart';
import 'package:flutter_chat_craft/common/config.dart';

/// @Author: Taxze
/// @GitHub: https://github.com/taxze6
/// @Email: taxze.xiaoyan@gmail.com
/// @Date: 2023/11/21
void main() {
  Config.init(() => runApp(ChatCraftApp()));
}
