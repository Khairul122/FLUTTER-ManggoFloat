import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plants.dart';

class PlantService {
  static const String baseUrl =
      'http://10.0.2.2/backend-manggofloat/ProdukAPI.php';

  static Future<List<Plant>> fetchPlants() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print("Fetched Plants: $jsonList"); // Tambahkan ini untuk debugging
      return Plant.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to load plants');
    }
  }
}
