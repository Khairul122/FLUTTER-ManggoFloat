import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:flutter_onboarding/ui/screens/widgets/plant_widget.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Plant> _addedToCartPlants = [];
  bool _isLoading = true;
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserDataAndCartPlants();
  }

  Future<void> _fetchUserDataAndCartPlants() async {
    try {
      var box = Hive.box('userBox');
      var userData = box.get('userData');
      int userId = userData != null ? int.tryParse(Map<String, dynamic>.from(userData)['id_pengguna'].toString()) ?? 0 : 0;

      print('User ID: $userId');

      if (userId != 0) {
        print('Fetching cart plants for user ID: $userId'); // Debugging
        final response = await http.get(
          Uri.parse('http://192.168.74.108/backend-manggofloat/PembelianAPI.php?id_pengguna=$userId'),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          try {
            final List<dynamic> responseBody = json.decode(response.body);
            print('Parsed response body: $responseBody'); // Debugging

            if (responseBody.isNotEmpty) {
              setState(() {
                _addedToCartPlants = responseBody.map((data) {
                  print('Plant data from API: $data'); // Debugging
                  return Plant.fromJson(data);
                }).toList();
                _calculateTotalPrice();
                print('Parsed plant data: $_addedToCartPlants'); // Debugging
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
          print('Failed to load cart plants, status code: ${response.statusCode}'); // Debugging
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        print('User ID is not available'); // Debugging
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching cart plants: $e');
    }
  }

  void _calculateTotalPrice() {
    int total = 0;
    for (var plant in _addedToCartPlants) {
      total += plant.price; // Gunakan totalPrice dari setiap produk
    }
    setState(() {
      _totalPrice = total;
    });
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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _addedToCartPlants.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return PlantWidget(
                              index: index,
                              plantList: _addedToCartPlants,
                            );
                          },
                        ),
                      ),
                      Column(
                        children: [
                          const Divider(
                            thickness: 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Totals',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                r'Rp' + _totalPrice.toString(),
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}