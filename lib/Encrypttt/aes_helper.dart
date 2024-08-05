import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class AESHelper {
  final key = Uint8List.fromList([
    50, 199, 10, 159, 132, 55, 236, 189, 51, 243, 244, 91, 17, 136, 39, 230
  ]);
  final iv = Uint8List.fromList([
    150, 9, 112, 39, 32, 5, 136, 255, 251, 43, 44, 191, 217, 236, 3, 106
  ]);

  String encryptString(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: encrypt.IV(iv));
    print("encrypted.base64 = ${encrypted.base64}");
    return encrypted.base64;
  }

  String decryptString(String encryptedText) {
    print("encryptedText = $encryptedText" );
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: encrypt.IV(iv));
    print("decrypted recipe = $decrypted");
    return decrypted;
  }

  Future<String> getRecipeOfTheDay(int luckyNumber) async {
    String encryptedNumber = encryptString(luckyNumber.toString());
    final response = await http.get(
      Uri.parse('http://192.168.1.201:8099/Yummy/Index?EncryptedNum=$encryptedNumber'),
    );

    if (response.statusCode == 200) {
      String encryptedRecipe = response.body;
      return decryptString(encryptedRecipe);
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}
