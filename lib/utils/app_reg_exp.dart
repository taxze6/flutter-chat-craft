class AppRegExp {
  ///用户名：只能为数字、英文字母，且不超过15位，不能出现空格、下划线。
  static RegExp userNameRegExp = RegExp(r'^[a-zA-Z0-9]{1,15}$');

  ///用户账户密码：只能为数字、英文字母和特殊字符，且长度为6-18位，不允许出现空格
  static RegExp userPwdRegExp = RegExp(r'^[\w!@#\$&*~]{6,18}$');

  static RegExp emailRegExp =
      RegExp("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$");
}
