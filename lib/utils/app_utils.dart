import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

class AppUtils {
  // Rsa Encryption
  static Future<String> encodeString(String data) async {
    final publicPem = await rootBundle.loadString('assets/key/public.pem');
    dynamic publicKey = RSAKeyParser().parse(publicPem);
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(data).base64.replaceAll(RegExp(r''), '');
  }
}
