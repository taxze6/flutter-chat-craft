import 'dart:convert';
import 'package:flutter_chat_craft/common/global_data.dart';
import 'user_info.dart';

class ConversationInfo {
  UserInfo userInfo;
  Message message;
  String previewText;
  int messageLength;

  ConversationInfo({
    required this.userInfo,
    required this.message,
    required this.previewText,
    this.messageLength = 0,
  });
}

class Message {
  String? sendTime;
  int? formId;
  int? targetId;
  int? type;
  int? contentType;
  String? content;

  Message({
    this.sendTime,
    this.formId,
    this.targetId,
    this.type,
    this.contentType,
    this.content,
  });

  Message.fromJson(Map<String, dynamic> json)
      : sendTime = json['createAt'],
        formId = json['userId'],
        targetId = json['targetId'],
        type = json['type'],
        contentType = json['contentType'],
        content = json['content'];

  factory Message.fromHeartbeat() {
    return Message(
      targetId: -1,
      type: ConversationType.heart,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.text,
      content: "heart",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": formId,
      "targetId": targetId,
      "type": type,
      "contentType": contentType,
      "content": content,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'Message{'
        'sendTime: $sendTime, '
        'formId: $formId, '
        'targetId: $targetId, '
        'type: $type, '
        'contentType: $contentType, '
        'content: $content'
        '}';
  }
}

/// Session Type
class ConversationType {
  /// Private Chat
  static const single = 1;

  /// Group
  static const group = 2;

  /// Notification
  static const notification = 3;

  static const heart = 0;
}

class MessageType {
  static const text = 101;

  static const picture = 102;

  static const voice = 103;

  static const video = 104;

  static const atText = 106;

  static const location = 109;
}

class MessageStatus {
  static const sending = 1;

  static const succeeded = 2;

  static const failed = 3;

  static const deleted = 4;
}
