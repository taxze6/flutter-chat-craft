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

  //relation
  static var addFriendWithUserName = "${Config.apiUrl}/relation/add_username";
  static var loadFriends = "${Config.apiUrl}/relation/list";

  //message
  static var sendUserMsg = "$webSocketUrl${Config.ip}/v1/message/send_user_msg";
  static var getRedisMsg = "${Config.apiUrl}/message/get_redis_msg";

  //upload
  static var uploadImage = "${Config.apiUrl}/upload/image";
}
