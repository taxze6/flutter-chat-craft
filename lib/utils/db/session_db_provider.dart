import 'package:flutter_chat_craft/common/global_data.dart';
import 'package:flutter_chat_craft/models/message.dart';
import 'package:flutter_chat_craft/models/user_info.dart';
import 'package:sqflite/sqflite.dart';

import 'base_db_provider.dart';

///conversation
class SessionDbProvider extends BaseDbProvider {
  final String name = "im_session";
  final String chatOwnerUserId = "chat_owner_user_id";
  final String chatUserID = "chat_user_id";
  final String chatUserName = "chat_user_name";
  final String chatEmail = "chat_email";
  final String chatPhone = "chat_phone";
  final String chatAvatar = "chat_avatar";
  final String chatMotto = "chat_motto";
  final String chatClientIp = "chat_client_ip";
  final String chatClientPort = "chat_client_port";
  final String chatUpdatedTime = "chat_updated_time";
  final String latestMessageId = "latest_message_id";
  final String latestMessageSendTime = "latest_message_send_time";
  final String latestMessageContentType = "latest_message_content_type";
  final String latestMessageContent = "latest_message_content";
  final String chatUnreadCount = "chat_unread_count";

  SessionDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        id integer primary key AUTOINCREMENT,
        $chatOwnerUserId integer not null,
        $chatUserID integer not null,
        $chatUserName text not null,
        $chatEmail text not null,
        $chatPhone text not null,
        $chatAvatar text not null,
        $chatMotto text not null,
        $chatClientIp text,
        $chatClientPort text,
        $chatUpdatedTime int not null,
        $latestMessageId text not null,
        $latestMessageSendTime text not null,
        $latestMessageContentType integer not null,
        $latestMessageContent text not null,
        $chatUnreadCount int not null)
      ''';
  }

  final UserInfo ownerUser = GlobalData.userInfo;

  //Check if the record exists.
  Future<List<Map<String, dynamic>>> _getConversationProvider(
    Database db,
    int ownerId,
    int userId,
    String messageId,
  ) async {
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $name where $chatOwnerUserId = $ownerId and $chatUserID = $userId and $latestMessageId = $messageId");
    return maps;
  }

  ///Insert to database
  Future<bool> insert(
      UserInfo user, Message message, int chatUnreadCount) async {
    Database db = await getDataBase();
    var userProvider = await _getConversationProvider(
      db,
      ownerUser.userID,
      user.userID,
      message.msgId!,
    );
    if (userProvider.isNotEmpty) {
      print("already exist message with messageId:${message.msgId}");
      return false;
    }
    var sql = '''
    insert into $name ($chatOwnerUserId, $chatUserID, $chatUserName, $chatEmail, $chatPhone, $chatAvatar, $chatMotto, $chatClientIp, $chatClientPort,
        $chatUpdatedTime, $latestMessageId, $latestMessageSendTime, $latestMessageContentType, $latestMessageContent, $chatUnreadCount
    ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    ''';
    int result = await db.rawInsert(sql, [
      ownerUser.userID,
      user.userID,
      user.userName,
      user.email,
      user.phone,
      user.avatar,
      user.motto,
      user.clientIp,
      user.clientPort,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.msgId,
      message.sendTime,
      message.contentType,
      message.content,
      chatUnreadCount,
    ]);
    return result > 0;
  }

  ///Update to Database
  Future<bool> update(
      UserInfo user, Message message, int chatUnreadCount) async {
    Database db = await getDataBase();
    var sql = '''
    update $name set
    $chatOwnerUserId = ?,
    $chatUserID = ?,
    $chatUserName = ?,
    $chatEmail = ?,
    $chatPhone = ?,
    $chatAvatar = ?,
    $chatMotto = ?,
    $chatClientIp = ?,
    $chatClientPort = ?,
    $chatUpdatedTime = ?,
    $latestMessageId = ?,
    $latestMessageSendTime = ?,
    $latestMessageContentType = ?,
    $latestMessageContent = ?,
    $chatUnreadCount = ?
    ''';
    int result = await db.rawUpdate(sql, [
      user.userID,
      user.userName,
      user.email,
      user.phone,
      user.avatar,
      user.motto,
      user.clientIp,
      user.clientPort,
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.msgId,
      message.sendTime,
      message.contentType,
      message.content,
      chatUnreadCount,
      message.msgId,
    ]);
    return result > 0;
  }

  ///Update ChatUnreadCount
  Future<bool> updateChatUnreadCount(int userId, int newUnreadCount) async {
    Database db = await getDataBase();
    var sql = '''
    update $name set
    $chatUnreadCount = ?
    where $chatOwnerUserId = ? and $chatUserID = ?
    ''';
    int result = await db.rawUpdate(sql, [
      newUnreadCount,
      ownerUser.userID,
      userId,
    ]);
    return result > 0;
  }

  ///Get All Conversation
  Future<List<ConversationInfo>> getAllConversations() async {
    Database db = await getDataBase();
    var sql = '''
    SELECT * FROM $name WHERE $chatOwnerUserId = ?
''';
    List<Map<String, dynamic>> conversations =
        await db.rawQuery(sql, [ownerUser.userID]);
    if (conversations.isNotEmpty) {
      return conversations.map((map) => parseConversationInfo(map)).toList();
    } else {
      return [];
    }
  }

  ConversationInfo parseConversationInfo(Map<String, dynamic> conversationMap) {
    UserInfo userInfo = UserInfo(
      userID: conversationMap[chatUserID],
      userName: conversationMap[chatUserName],
      email: conversationMap[chatEmail],
      phone: conversationMap[chatPhone],
      avatar: conversationMap[chatAvatar],
      motto: conversationMap[chatMotto],
      clientIp: conversationMap[chatClientIp],
      clientPort: conversationMap[chatClientPort],
    );

    Message message = Message(
      msgId: conversationMap[latestMessageId],
      sendTime: conversationMap[latestMessageSendTime],
      formId: conversationMap[chatUserID],
      targetId: conversationMap[chatOwnerUserId],
      type: null,
      contentType: conversationMap[latestMessageContentType],
      status: null,
      content: conversationMap[latestMessageContent],
      sound: null,
    );
    String previewText = conversationMap[latestMessageContent];
    int messageLength = conversationMap[latestMessageContent].length;

    return ConversationInfo(
      userInfo: userInfo,
      message: message,
      previewText: previewText,
      messageLength: messageLength,
    );
  }
}
