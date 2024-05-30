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
    const String baseUrl = 'http://192.168.74.108/backend-manggofloat/'; // Tambahkan base URL di sini

    return Plant(
      plantId: int.parse(json['id_produk']), // Konversi ke int
      price: int.parse(json['harga_produk']), // Konversi ke int
      plantName: json['nama_produk'],
      imageURL: baseUrl + json['gambar_produk'], // Bangun URL gambar lengkap
      description: json['deskripsi_produk'],
      stock: int.parse(json['stok_produk']), // Konversi ke int jika perlu
      isFavorated: false,
      isSelected: false,
    );
  }

  static List<Plant> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Plant.fromJson(json)).toList();
  }

  static List<Plant> plantList = [];

  static List<Plant> getFavoratedPlants() {
    return plantList.where((element) => element.isFavorated).toList();
  }

  static List<Plant> addedToCartPlants() {
    return plantList.where((element) => element.isSelected).toList();
  }
}
