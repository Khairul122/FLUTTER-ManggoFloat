import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:flutter_onboarding/ui/screens/cod_page.dart';
import 'package:flutter_onboarding/ui/screens/dana_page.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final Plant plant;

  PaymentPage({required this.plant});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isCODSelected = true;
  bool isBankTransferSelected = false;

  void _showDialog(String title, String message, {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: onOkPressed ?? () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePembelian(int pembelianId, String statusPembayaran, double totalHarga) async {
    try {
      var body = {
        'id_pembelian': pembelianId.toString(),
        'status_pembayaran': statusPembayaran,
        'total_harga': totalHarga.toString(),
      };

      // Logging data yang dikirim ke API
      print("Sending data to API:");
      print("id_pembelian: $pembelianId");
      print("status_pembayaran: $statusPembayaran");
      print("total_harga: $totalHarga");

      final response = await http.put(
        Uri.parse('http://10.0.2.2/backend-manggofloat/PembelianAPI.php'), 
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      // Logging respons dari API
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          // Jika berhasil
          _showDialog('Berhasil', 'Pesanan berhasil disimpan', onOkPressed: () {
            Navigator.of(context).pop(); // Menutup dialog
            _navigateToPaymentPage(statusPembayaran);
          });
        } else {
          // Jika gagal
          _showDialog('Gagal', 'Pesanan gagal: ${responseBody['message']}');
        }
      } else {
        // Jika gagal
        _showDialog('Gagal', 'Pesanan gagal: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showDialog('Error', 'Terjadi kesalahan: $e');
      print('Error during checkout: $e');
    }
  }

  void _navigateToPaymentPage(String statusPembayaran) {
    if (statusPembayaran == 'COD') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CODPage()),
      );
    } else if (statusPembayaran == 'DANA') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DanaPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userBox');
    var userData = box.get('userData');
    String namaPengguna = userData != null
        ? Map<String, dynamic>.from(userData)['nama_pengguna']
        : '';
    String noTelepon = userData != null
        ? Map<String, dynamic>.from(userData)['no_telepon']
        : '';
    String alamat =
        userData != null ? Map<String, dynamic>.from(userData)['alamat'] : '';
    double ongkir = userData != null
        ? double.tryParse(Map<String, dynamic>.from(userData)['ongkir'].toString()) ?? 0
        : 0;

    double subtotalProduk = widget.plant.price * widget.plant.jumlah.toDouble();
    double totalHarga = subtotalProduk + ongkir;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Constants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat Pengiriman',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('$namaPengguna | $noTelepon'),
                  Text(alamat),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.network(
                    widget.plant.imageURL,
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plant.plantName,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text('Jumlah: ${widget.plant.jumlah}'),
                      Text('Rp${formatCurrency(widget.plant.price.toDouble())}'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Opsi Pengiriman', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reguler',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rp ${formatCurrency(ongkir)}'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isCODSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isCODSelected = value!;
                            isBankTransferSelected = !value;
                          });
                        },
                      ),
                      Text('COD'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isBankTransferSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isBankTransferSelected = value!;
                            isCODSelected = !value;
                          });
                        },
                      ),
                      Text('DANA'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rincian Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  _buildPaymentDetailRow('Subtotal untuk Produk',
                      'Rp${formatCurrency(subtotalProduk)}'),
                  _buildPaymentDetailRow('Subtotal Pengiriman', 'Rp ${formatCurrency(ongkir)}'),
                  Divider(),
                  _buildPaymentDetailRow(
                    'Total Pembayaran',
                    'Rp${formatCurrency(totalHarga)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String statusPembayaran = isCODSelected ? 'COD' : 'DANA';
                  try {
                    // Verifikasi ID Pembelian sebelum melakukan update
                    var box = Hive.box('userBox');
                    var userData = box.get('userData');
                    int userId = userData != null
                        ? int.tryParse(Map<String, dynamic>.from(userData)['id_pengguna']
                                .toString()) ??
                            0
                        : 0;

                    // Mengambil ID Pembelian yang sesuai untuk user
                    final response = await http.get(
                      Uri.parse(
                          'http://10.0.2.2/backend-manggofloat/PembelianAPI.php?id_pengguna=$userId'),
                    );

                    if (response.statusCode == 200) {
                      final List<dynamic> responseBody = json.decode(response.body);
                      if (responseBody.isNotEmpty) {
                        final int pembelianId = int.parse(responseBody.last['id_pembelian']); // Mengambil ID Pembelian terbaru
                        await _updatePembelian(pembelianId, statusPembayaran, totalHarga);
                      } else {
                        _showDialog('Gagal', 'Tidak ada pembelian yang ditemukan.');
                      }
                    } else {
                      _showDialog('Gagal', 'Gagal mengambil data pembelian.');
                    }
                  } catch (e) {
                    _showDialog('Error', 'Terjadi kesalahan: $e');
                    print('Error during checkout: $e');
                  }
                },
                child: Text('Buat Pesanan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  primary: Constants.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'id');
    return formatter.format(amount);
  }

  Widget _buildPaymentDetailRow(String title, String amount,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
