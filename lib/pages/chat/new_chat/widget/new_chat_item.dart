import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_info.dart';

class NewChatItem extends StatelessWidget {
  const NewChatItem({
    Key? key,
    required this.user,
    this.isShowSeparator = true,
  }) : super(key: key);

  // final UserInfo user;
  final String user;

  final bool isShowSeparator;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: isShowSeparator
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                )
              : null,
        ),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 16.0),
        child: Text(
          user,
          // user.userName,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
