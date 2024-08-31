import 'package:encrypt/encrypt.dart';

class EncryptedData {
  final String encryptedData;
  final String iv;

  EncryptedData({required this.encryptedData, required this.iv});

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      encryptedData: json['encryptedData'] as String,
      iv: json['iv'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encryptedData': encryptedData,
      'iv': iv,
    };
  }
}

class AESCipherService {
  static String key = const String.fromEnvironment('key');
  // Static method for encryption
  static EncryptedData encrypt(String plaintext) {
    // Convert the key into a 256-bit format
    final key256 = Key.fromUtf8(key);

    // Generate a random 128-bit IV (Initialization Vector)
    final iv128 = IV.fromSecureRandom(16);

    // Create an AES encrypter in CBC mode
    final encrypter = Encrypter(AES(key256, mode: AESMode.cbc));

    // Encrypt the plaintext using the key and IV
    final encrypted = encrypter.encrypt(plaintext, iv: iv128);

    // Return the encrypted data and IV as hexadecimal strings
    return EncryptedData(encryptedData: encrypted.base64, iv: iv128.base64);
  }

  // Static method for decryption
  static String decrypt(String encryptedData, String iv) {
    // Convert the key into a 256-bit format
    final key256 = Key.fromUtf8(key);

    // Convert the IV from a hexadecimal string back into bytes
    final iv128 = IV.fromBase64(iv);

    // Create an AES encrypter in CBC mode
    final encrypter = Encrypter(AES(key256, mode: AESMode.cbc));

    // Decrypt the encrypted data using the key and IV
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: iv128);

    // Return the decrypted plaintext
    return decrypted;
  }
}
