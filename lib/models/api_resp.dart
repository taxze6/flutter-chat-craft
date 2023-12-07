class ApiResp {
  int code;
  String message;
  dynamic data;

  ApiResp({required this.code, required this.message, required this.data});

  ApiResp.fromJson(Map<String, dynamic> map)
      : code = map["Code"],
        message = map["Message"],
        data = map["Data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Code'] = code;
    data['Message'] = message;
    data['Data'] = data;
    return data;
  }
}
