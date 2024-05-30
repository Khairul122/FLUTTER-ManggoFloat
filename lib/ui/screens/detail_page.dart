import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:flutter_onboarding/services/plant_services.dart';
import 'package:flutter_onboarding/ui/screens/cart_page.dart';

class DetailPage extends StatefulWidget {
  final int plantId;
  const DetailPage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Plant> _plant;
  List<Plant> _cart = [];

  @override
  void initState() {
    super.initState();
    _plant = _fetchPlantById(widget.plantId);
  }

  Future<Plant> _fetchPlantById(int id) async {
    List<Plant> plants = await PlantService.fetchPlants();
    return plants.firstWhere((plant) => plant.plantId == id);
  }

  //Toggle Favorite button
  bool toggleIsFavorated(bool isFavorited) {
    return !isFavorited;
  }

  //Toggle add remove from cart
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
                    padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
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
  
    );
  }
}
