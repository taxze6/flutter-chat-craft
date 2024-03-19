import 'package:flutter_chat_craft/common/ip_config.dart';

import 'config.dart';

String webSocketUrl = "ws://";

class Urls {
  //user
  static var login = "${Config.apiUrl}/user/login";
  static var emailLogin = "${Config.apiUrl}/user/email_login";
  static var emailLoginCodeCheck =
      "${Config.apiUrl}/user/email_login_code_check";
  static var register = "${Config.apiUrl}/user/register";
  static var emailRegisterCodeCheck =
      "${Config.apiUrl}/user/register_email_code_check";
  static var findUserWithName = "${Config.apiUrl}/user/find_user_with_name";

  static var getUserShowStoryList =
      "${Config.apiUrl}/user/get_user_show_story_list";

  static var addOrRemoveUserStoryLike = "${Config.apiUrl}/user/add_story_like";

  static var addUserStoryComment = "${Config.apiUrl}/user/add_story_comment";
  static var modifyUserInfo = "${Config.apiUrl}/user/user_info_update";
  static var modifyPassword = "${Config.apiUrl}/user/user_info_password_update";

  //relation
  static var addFriendWithUserName = "${Config.apiUrl}/relation/add_username";
  static var loadFriends = "${Config.apiUrl}/relation/list";

  //message
  static var sendUserMsg =
      "$webSocketUrl${IpConfig.ip}/v1/message/send_user_msg";
  static var getRedisMsg = "${Config.apiUrl}/message/get_redis_msg";

  //upload
  static var uploadFile = "${Config.apiUrl}/upload/file";

  //Init File-Download
  static var downloadEmojiZip = "${Config.apiUrl}/upload/getEmojiZip";
}
