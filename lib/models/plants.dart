class Plant {
  final int plantId;
  final int price;
  final String plantName;
  final String imageURL;
  final String description;
  final int stock;
  bool isFavorated;
  bool isSelected;

  Plant({
    required this.plantId,
    required this.price,
    required this.plantName,
    required this.imageURL,
    required this.description,
    required this.stock,
    required this.isFavorated,
    required this.isSelected,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: json['id_produk'],
      price: json['harga_produk'],
      plantName: json['nama_produk'],
      imageURL: json['gambar_produk'],
      description: json['deskripsi_produk'],
      stock: json['stok_produk'],
      isFavorated: false, // Assuming initial state
      isSelected: false, // Assuming initial state
    );
  }

  static List<Plant> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Plant.fromJson(json)).toList();
  }

  static List<Plant> plantList = [];

  // Get the favorited items
  static List<Plant> getFavoritedPlants() {
    return plantList.where((element) => element.isFavorated).toList();
  }

  // Get the cart items
  static List<Plant> addedToCartPlants() {
    return plantList.where((element) => element.isSelected).toList();
  }
}
