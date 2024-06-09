import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressService {
  static Future<List<Map<String, dynamic>>> fetchAddresses() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/backend-penjualan/AlamatAPI.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((address) => address as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load addresses');
    }
  }
}
