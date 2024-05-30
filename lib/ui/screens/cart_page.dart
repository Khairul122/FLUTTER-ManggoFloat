import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:async';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Plant> _addedToCartPlants = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchUserDataAndCartPlants();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchUserDataAndCartPlants();
    });
  }

  Future<void> _fetchUserDataAndCartPlants() async {
    try {
      var box = Hive.box('userBox');
      var userData = box.get('userData');
      int userId = userData != null ? int.tryParse(Map<String, dynamic>.from(userData)['id_pengguna'].toString()) ?? 0 : 0;

      print('User ID: $userId');

      if (userId != 0) {
        print('Fetching cart plants for user ID: $userId');
        final response = await http.get(
          Uri.parse('http://192.168.74.108/backend-manggofloat/PembelianAPI.php?id_pengguna=$userId'),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          try {
            final List<dynamic> responseBody = json.decode(response.body);
            print('Parsed response body: $responseBody');

            if (responseBody.isNotEmpty) {
              setState(() {
                _addedToCartPlants = responseBody.map((data) {
                  print('Plant data from API: $data');
                  final plant = Plant.fromJson(data);
                  print('Parsed plant: ${plant.plantName}, price: ${plant.price}');
                  return plant;
                }).toList();
                print('Parsed plant data: $_addedToCartPlants');
                _isLoading = false;
              });
            } else {
              print('No plants found in the cart for user ID: $userId');
              setState(() {
                _isLoading = false;
              });
            }
          } catch (e) {
            print('Error parsing response body: $e');
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          print('Failed to load cart plants, status code: ${response.statusCode}');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        print('User ID is not available');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching cart plants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _addedToCartPlants.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset('assets/images/add-cart.png'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your Cart is Empty',
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                  height: size.height,
                  child: ListView.builder(
                    itemCount: _addedToCartPlants.length,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final plant = _addedToCartPlants[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(plant.imageURL),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.plantName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Rp${plant.price}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Jumlah: ${plant.jumlah}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                   const SizedBox(height: 10),
                                  Text(
                                    'Total Harga: ${plant.totalHarga}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Status: ${plant.statusPembelian}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: plant.statusPembelian == 'Pending' ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
