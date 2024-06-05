import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.5.108/backend-manggofloat/PenggunaAPI.php';

  static Future<Map<String, dynamic>> registerUser({
    required String namaPengguna,
    required String email,
    required String password,
    required String alamat,
    required String noTelepon,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'action': 'register',
        'nama_pengguna': namaPengguna,
        'email': email,
        'password': password,
        'alamat': alamat,
        'no_telepon': noTelepon,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}
