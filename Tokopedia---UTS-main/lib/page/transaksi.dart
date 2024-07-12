import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransaksiPage extends StatefulWidget {
  final int userId;
  const TransaksiPage({Key? key, required this.userId}) : super(key: key);

  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  late Future<List<Map<String, dynamic>>> _transaksiList;

  @override
  void initState() {
    super.initState();
    _transaksiList = fetchTransaksiList();
  }

  Future<List<Map<String, dynamic>>> fetchTransaksiList() async {
    String id = widget.userId.toString();
    final response = await http.get(Uri.parse(
        'https://93dd-36-71-137-240.ngrok-free.app/api/transaksi/$id'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> transaksiList =
          data.map((item) => item as Map<String, dynamic>).toList();
      return transaksiList;
    } else {
      throw Exception('Failed to load transaction list');
    }
  }

  Future<void> deleteTransaksi(int transaksiId) async {
    final response = await http.delete(
      Uri.parse(
          'https://93dd-36-71-137-240.ngrok-free.app/api/transaksi/$transaksiId'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      // Jika berhasil hapus, refresh daftar transaksi
      _refreshTransaksiList();
    } else {
      print('Failed to delete transaction');
    }
  }

  Future<void> _refreshTransaksiList() async {
    setState(() {
      _transaksiList = fetchTransaksiList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
        backgroundColor: Colors.green, // Sesuaikan warna dengan Tokopedia
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transaksiList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> transaksiList = snapshot.data!;
            return ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> transaksi = transaksiList[index];
                DateTime tanggal =
                    DateTime.parse(transaksi['tanggal']).toLocal();
                String formattedDate =
                    "${tanggal.day}-${tanggal.month}-${tanggal.year}";

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaksi['nama_barang'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Toko: ${transaksi['nama_toko']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Tanggal: $formattedDate',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Harga: ${transaksi['harga']}',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Jumlah: ${transaksi['jumlah']}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                          'Anda yakin ingin menghapus transaksi ini?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Batal'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                        TextButton(
                                          child: Text('Hapus'),
                                          onPressed: () {
                                            deleteTransaksi(transaksi['id']);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
