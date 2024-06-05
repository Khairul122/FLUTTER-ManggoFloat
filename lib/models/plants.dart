class Plant {
  final int plantId;
  final int price;
  final String plantName;
  final String imageURL;
  final String description;
  final int stock;
  final int jumlah;
  final String statusPembelian;
  final int totalHarga;
  bool isFavorated;
  bool isSelected;

  Plant({
    required this.plantId,
    required this.price,
    required this.plantName,
    required this.imageURL,
    required this.description,
    required this.stock,
    required this.jumlah,
    required this.statusPembelian,
    required this.totalHarga,
    required this.isFavorated,
    required this.isSelected,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'http://192.168.5.108/backend-manggofloat/';

    // Debug log untuk JSON yang diterima
    print("Parsing Plant from JSON: $json");

    int plantId = int.tryParse(json['id_produk']?.toString() ?? '0') ?? 0;
    String? statusPembelian = json['status_pembelian'];

    // Debug log untuk status_pembelian
    print("Parsed status_pembelian: $statusPembelian");

    return Plant(
      plantId: plantId,
      price: int.tryParse(json['harga_produk']?.toString() ?? '0') ?? 0,
      plantName: json['nama_produk'] ?? '',
      imageURL: baseUrl + (json['gambar_produk'] ?? ''),
      description: json['deskripsi_produk'] ?? '',
      stock: int.tryParse(json['stok_produk']?.toString() ?? '0') ?? 0,
      jumlah: int.tryParse(json['jumlah']?.toString() ?? '0') ?? 0,
      statusPembelian: statusPembelian ?? '',
      totalHarga: int.tryParse(json['total_harga']?.toString() ?? '0') ?? 0,
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
