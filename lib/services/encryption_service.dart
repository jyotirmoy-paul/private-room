import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:privateroom/utility/sensitive_constants.dart';

class EncryptionService {
  static String _getModifiedPasswordFrom(String initialKey) {
    assert(initialKey.length <= 32);

    var paddingNeeded = 32 - initialKey.length;

    return paddingNeeded == 0
        ? initialKey
        : initialKey + developerKey.substring(0, paddingNeeded);
  }

  static String _getModifiedIvPasswordFrom(String initialIV) {
    initialIV = initialIV.substring(0, min(10, initialIV.length));
    var paddingNeeded = 16 - initialIV.length;
    return initialIV + developerKey.substring(0, paddingNeeded);
  }

  static String decrypt(String ivPassword, String password, String base64Data) {
    final decryptionPass = _getModifiedPasswordFrom(password);
    final iv = IV.fromUtf8(_getModifiedIvPasswordFrom(ivPassword));

    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(decryptionPass),
        mode: AESMode.cbc,
      ),
    );

    return encrypter.decrypt64(base64Data, iv: iv);
  }

  static String encrypt(String ivPassword, String password, String data) {
    final encryptionPassword = _getModifiedPasswordFrom(password);
    final iv = IV.fromUtf8(_getModifiedIvPasswordFrom(ivPassword));

    final encrypter = Encrypter(
      AES(
        Key.fromUtf8(encryptionPassword),
        mode: AESMode.cbc,
      ),
    );

    return encrypter.encrypt(data, iv: iv).base64;
  }
}
