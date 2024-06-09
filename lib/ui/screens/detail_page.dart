import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:flutter_onboarding/services/plant_services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class DetailPage extends StatefulWidget {
  final int plantId;
  const DetailPage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Plant> _plant;
  List<Plant> _cart = [];
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _plant = _fetchPlantById(widget.plantId);
  }

  Future<Plant> _fetchPlantById(int id) async {
    List<Plant> plants = await PlantService.fetchPlants();
    return plants.firstWhere((plant) => plant.plantId == id);
  }

  Future<Map<String, dynamic>> getUserData() async {
    var box = Hive.box('userBox');
    var userData = box.get('userData');
    return userData != null ? Map<String, dynamic>.from(userData) : {};
  }

  // Function to show dialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to handle the checkout process
  Future<void> checkout(int userId, int productId, int quantity,
      double totalPrice, String purchaseDate) async {
    try {
      var body = {
        'id_pengguna': userId.toString(),
        'id_produk': productId.toString(),
        'jumlah': quantity.toString(),
        'total_harga': totalPrice.toString(),
        'tanggal_pembelian': purchaseDate,
        'status_pembelian': 'Diproses',
        'status_pembayaran': 'Belum Dibayar', // Menambahkan status pembayaran
      };

      print("Sending data to API: $body"); // Logging data yang dikirim ke API

      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/backend-manggofloat/PembelianAPI.php'), // Sesuaikan URL backend Anda
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          // Jika berhasil
          _showDialog(context, 'Berhasil', 'Checkout berhasil');
        } else {
          // Jika gagal
          _showDialog(
              context, 'Gagal', 'Checkout gagal: ${responseBody['message']}');
        }
      } else {
        // Jika gagal
        _showDialog(
            context, 'Gagal', 'Checkout gagal: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showDialog(context, 'Error', 'Terjadi kesalahan: $e');
      print('Error during checkout: $e');
    }
  }

  // Function to toggle favorite status
  bool toggleIsFavorated(bool isFavorited) {
    return !isFavorited;
  }

  // Function to toggle add/remove from cart
  bool toggleIsSelected(bool isSelected) {
    return !isSelected;
  }

  void _addToCart(Plant plant) {
    setState(() {
      if (!_cart.contains(plant)) {
        _cart.add(plant);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<Plant>(
        future: _plant,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Plant plant = snapshot.data!;
            return Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Constants.primaryColor.withOpacity(.15),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          debugPrint('favorite');
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Container(
                    width: size.width * .8,
                    height: size.height * .8,
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 0,
                          child: SizedBox(
                            height: 350,
                            child: Image.network(plant.imageURL),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 0,
                          child: SizedBox(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 80, left: 30, right: 30),
                    height: size.height * .5,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.4),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  plant.plantName,
                                  style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  r'Rp' + plant.price.toString(),
                                  style: TextStyle(
                                    color: Constants.blackColor,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Expanded(
                          child: Text(
                            plant.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 18,
                              color: Constants.blackColor.withOpacity(.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Plant not found'));
          }
        },
      ),
      floatingActionButton: FutureBuilder<Plant>(
        future: _plant,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Plant plant = snapshot.data!;
            return SizedBox(
              width: size.width * .9,
              height:
                  100, // Adjusted height to accommodate the quantity selector
              child: Column(
                children: [
                  QuantitySelector(
                    quantity: _quantity,
                    onChanged: (newQuantity) {
                      setState(() {
                        _quantity = newQuantity;
                      });
                    },
                  ),
                  const SizedBox(height: 10), // Add some spacing
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              Map<String, dynamic> userData =
                                  await getUserData();
                              print(
                                  "User Data: $userData"); // Logging untuk debugging
                              int userId = int.parse(userData['id_pengguna']
                                  .toString()); // Ambil ID pengguna dari data yang disimpan dan konversi ke int
                              double totalPrice = (plant.price * _quantity)
                                  .toDouble(); // Total harga
                              String purchaseDate = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()); // Tanggal pembelian

                              await checkout(userId, plant.plantId, _quantity,
                                  totalPrice, purchaseDate);
                            } catch (e) {
                              _showDialog(
                                  context, 'Error', 'Terjadi kesalahan: $e');
                              print('Error during checkout: $e');
                            }
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color: Constants.primaryColor.withOpacity(.3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'ORDER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (quantity > 1) {
              onChanged(quantity - 1);
            }
          },
        ),
        Text(
          quantity.toString(),
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            onChanged(quantity + 1);
          },
        ),
      ],
    );
  }
}
