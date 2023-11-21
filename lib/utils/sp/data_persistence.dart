import 'sp_util.dart';

class DataPersistence {
  static const _SERVER = "server";
  static const _language = "language";
  static const _LOGIN_INFO = 'loginCertificate';

  static Future<bool>? putLanguage(int index) {
    return SpUtil.putInt(_language, index);
  }

  static int? getLanguage() {
    return SpUtil.getInt(_language);
  }
}
