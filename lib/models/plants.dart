class Plant {
  final int plantId;
  final int price;
  final String size;
  final double rating;
  final int humidity;

  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Plant(
      {required this.plantId,
      required this.price,
      required this.plantName,
      required this.size,
      required this.rating,
      required this.humidity,
      required this.imageURL,
      required this.isFavorated,
      required this.decription,
      required this.isSelected});

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
        plantId: 0,
        price: 22,
        plantName: 'Mango Juice',
        size: 'Small',
        rating: 4.5,
        humidity: 34,
        imageURL: 'assets/images/mango.png',
        isFavorated: false,
        decription:
            'Jus mangga ini dapat di pesan menggunakan es atau tidak, tinggalkan di cacatan',
        isSelected: false),
    Plant(
        plantId: 1,
        price: 11,
        plantName: 'Orange Juice',
        size: 'Variasi',
        rating: 4.8,
        humidity: 56,
        imageURL: 'assets/images/orange.png',
        isFavorated: false,
        decription:
            'Jus jeruk ini dapat di pesan menggunakan es atau tidak, tinggalkan di cacatan',
        isSelected: false),
    Plant(
        plantId: 2,
        price: 18,
        plantName: 'Berry Juice',
        size: 'Variasi',
        rating: 4.7,
        humidity: 34,
        imageURL: 'assets/images/berry.png',
        isFavorated: false,
        decription:
            'Jus berry ini dapat di pesan menggunakan es atau tidak, tinggalkan di cacatan',
        isSelected: false),
    Plant(
        plantId: 3,
        price: 30,
        plantName: 'mango float',
        size: 'Small',
        rating: 4.5,
        humidity: 35,
        imageURL: 'assets/images/float.png',
        isFavorated: false,
        decription:
            'Jus mangga ini dapat di pesan menggunakan es atau tidak, tinggalkan di cacatan',
        isSelected: false),
    Plant(
        plantId: 4,
        price: 24,
        plantName: 'Stawberry Float',
        size: 'Large',
        rating: 4.1,
        humidity: 66,
        imageURL: 'assets/images/strawberry.png',
        isFavorated: false,
        decription:
            'Jus strawberry ini dapat di pesan menggunakan es atau tidak, tinggalkan di cacatan',
        isSelected: false),
  ];

  //Get the favorated items
  static List<Plant> getFavoritedPlants() {
    List<Plant> _travelList = Plant.plantList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

  //Get the cart items
  static List<Plant> addedToCartPlants() {
    List<Plant> _selectedPlants = Plant.plantList;
    return _selectedPlants
        .where((element) => element.isSelected == true)
        .toList();
  }
}
