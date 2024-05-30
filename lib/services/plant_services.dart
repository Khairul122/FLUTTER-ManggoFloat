import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plants.dart';

class PlantService {
  static const String baseUrl = 'http://192.168.74.108/backend-manggofloat/PenggunaAPI.php';

  static Future<List<Plant>> fetchPlants() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return Plant.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to load plants');
    }
  }
}
