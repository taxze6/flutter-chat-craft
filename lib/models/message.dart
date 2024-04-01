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
  String? msgId;
  String? sendTime;
  int? formId;
  int? targetId;
  int? type;
  int? contentType;
  int? status;
  String content;
  String messageSenderName;
  String messageSenderFaceUrl;
  ImageElement? image;
  SoundElement? sound;
  Message? quoteMessage;
  List<String>? replyEmojis;

  Message({
    this.msgId,
    this.sendTime,
    this.formId,
    this.targetId,
    this.type,
    this.contentType,
    this.status,
    required this.content,
    required this.messageSenderName,
    required this.messageSenderFaceUrl,
    this.image,
    this.sound,
    this.quoteMessage,
    this.replyEmojis,
  });

  Message.fromJson(Map<String, dynamic> json)
      : msgId = json['msgId'],
        sendTime = json['createAt'],
        formId = json['userId'],
        targetId = json['targetId'],
        type = json['type'],
        contentType = json['contentType'],
        status = json['status'],
        content = json['content'] ?? "",
        messageSenderName = json['messageSenderName'] ?? "",
        messageSenderFaceUrl = json['messageSenderFaceUrl'] ?? "",
        image =
            json['image'] != null ? ImageElement.fromJson(json['image']) : null,
        sound =
            json['sound'] != null ? SoundElement.fromJson(json['sound']) : null,
        quoteMessage = json['quoteMessage'] != null
            ? Message.fromJson(json['quoteMessage'])
            : null,
        replyEmojis = json["replyEmojis"] != null ? List<String>.from(json["replyEmojis"]) : <String>[];

  factory Message.fromHeartbeat() {
    return Message(
      msgId: "-1",
      targetId: -1,
      type: ConversationType.heart,
      formId: GlobalData.userInfo.userID,
      contentType: MessageType.text,
      content: "heart",
      messageSenderName: GlobalData.userInfo.userName,
      messageSenderFaceUrl: GlobalData.userInfo.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "msgId": msgId,
      "userId": formId,
      "targetId": targetId,
      "type": type,
      "contentType": contentType,
      "status": status,
      "content": content,
      "messageSenderName": messageSenderName,
      "messageSenderFaceUrl": messageSenderFaceUrl,
      "sendTime": sendTime,
      "image": image,
      "sound": sound,
      "quoteMessage": quoteMessage,
      "replyEmojis": replyEmojis,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'Message{'
        'msgId:$msgId,'
        'sendTime: $sendTime, '
        'formId: $formId, '
        'targetId: $targetId, '
        'type: $type, '
        'contentType: $contentType, '
        'status:$status,'
        'content: $content,'
        'messageSenderName: $messageSenderName,'
        'messageSenderFaceUrl: $messageSenderFaceUrl,'
        'image:${image.toString()},'
        'sound:${sound.toString()},'
        'quoteMessage:${quoteMessage.toString()},'
        'replyEmoji:${replyEmojis.toString()},'
        '}';
  }

  void update(Message message) {
    // if (this != message) return;
    msgId = message.msgId;
    sendTime = message.sendTime;
    formId = message.formId;
    targetId = message.targetId;
    type = message.type;
    contentType = message.contentType;
    status = message.status;
    content = message.content;
    messageSenderName = message.messageSenderName;
    messageSenderFaceUrl = message.messageSenderFaceUrl;
    image = message.image;
    sound = message.sound;
    quoteMessage = message.quoteMessage;
    replyEmojis = message.replyEmojis;
  }
}

class ImageElement {
  String? image;
  double? imageWidth;
  double? imageHeight;
  double? fileSize;

  ImageElement({
    this.image,
    this.imageWidth,
    this.imageHeight,
    this.fileSize,
  });

  ImageElement.fromJson(Map<String, dynamic> json)
      : image = json['imageUrl'],
        imageWidth = json['imageWidth']?.toDouble(),
        imageHeight = json['imageHeight']?.toDouble(),
        fileSize = json['fileSize']?.toDouble();

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": image,
      "imageWidth": imageWidth,
      "imageHeight": imageHeight,
      "fileSize": fileSize,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

/// Voice message content
class SoundElement {
  /// URL address
  String? sourceUrl;

  /// Local address

  String? soundPath;

  /// Voice file size
  double? dataSize;

  /// time
  int? duration;

  SoundElement({this.sourceUrl, this.soundPath, this.dataSize, this.duration});

  SoundElement.fromJson(Map<String, dynamic> json) {
    sourceUrl = json['sourceUrl'];
    soundPath = json['soundPath'];
    dataSize = json['dataSize'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sourceUrl'] = sourceUrl;
    data['soundPath'] = soundPath;
    data['dataSize'] = dataSize;
    data['duration'] = duration;
    return data;
  }

  @override
  String toString() {
    return 'SoundElem{sourceUrl: $sourceUrl, soundPath: $soundPath, dataSize: $dataSize, duration: $duration}';
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

  static const atText = 105;

  static const location = 106;

  static const quote = 107;

  static const replyEmoji = 108;

  // static const updateEmoji = 108;

  static const typing = 1000;
}

class MessageStatus {
  static const sending = 1;

  static const succeeded = 2;

  static const failed = 3;

  static const deleted = 4;
}

const typingId = "typingId";
