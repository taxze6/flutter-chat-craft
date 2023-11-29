class ApiResp {
  int code;
  String message;
  dynamic data;

  ApiResp({required this.code, required this.message, required this.data});

  ApiResp.fromJson(Map<String, dynamic> map)
      : code = map["code"],
        message = map["message"],
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}
