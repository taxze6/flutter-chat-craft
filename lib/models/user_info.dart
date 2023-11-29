class UserInfo {
  int userID;
  String userName;
  String email;
  String phone;
  String avatar;
  String motto;
  String clientIp;
  String clientPort;

  UserInfo({
    required this.userID,
    required this.userName,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.motto,
    required this.clientIp,
    required this.clientPort,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : userID = json['id'],
        userName = json['name'],
        email = json['email'],
        phone = json['phone'],
        avatar = json['avatar'],
        motto = json['motto'],
        clientIp = json['client_ip'],
        clientPort = json['client_port'];

  Map<String, dynamic> toJson() {
    return {
      'id': userID,
      'name': userName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'motto': motto,
      'client_ip': clientIp,
      'client_port': clientPort,
    };
  }
}