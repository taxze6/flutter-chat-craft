import 'dart:ui';

import 'user_info.dart';

class ContactModel {
  final String section;
  final List<String> users;

  // final List<UserInfo> users;

  ContactModel({
    required this.section,
    required this.users,
  });
}

class CursorInfoModel {
  final String title;
  final Offset offset;

  CursorInfoModel({
    required this.title,
    required this.offset,
  });
}
