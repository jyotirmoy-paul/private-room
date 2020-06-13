import 'dart:convert';
import 'package:privateroom/services/encryption_service.dart';

class EncodingDecodingService {
  static String encodeAndEncrypt(
      Map<String, dynamic> data, String ivPassword, String password) {
    String encodedString = jsonEncode(data);

    return EncryptionService.encrypt(ivPassword, password, encodedString);
  }

  static Map<String, dynamic> decryptAndDecode(
      String data, String ivPassword, String password) {
    String decryptedString =
        EncryptionService.decrypt(ivPassword, password, data);

    return jsonDecode(decryptedString);
  }
}
