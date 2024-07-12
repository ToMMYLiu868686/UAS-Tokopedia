import 'package:flutter/material.dart';
import 'package:tokopedia_ui/home/authscreen.dart';
import 'package:tokopedia_ui/home/widget/custom.dart';
import 'package:tokopedia_ui/home/widget/menu.dart';
import 'package:tokopedia_ui/home/widget/sale.dart';
import 'package:tokopedia_ui/page/transaksi.dart';
import 'package:tokopedia_ui/page/akun.dart';

//userid gunanya untuk filter data user mana yang mau ditampilkan dari API
class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      BuatKamuPage(),
      TransaksiPage(userId: widget.userId),
      AkunPage(userId: widget.userId),
    ];
  }

//berguna untuk navigasi pada aplikasi untuk mengetahui saat ini lagi di page mana
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe65b, fontFamily: 'MaterialIcons')),
            label: "Buat Kamu",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe60b, fontFamily: 'MaterialIcons')),
            label: "Transaksi",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xed20, fontFamily: 'MaterialIcons')),
            label: "Akun",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

// Halaman yang ditampilkan berdasarkan pilihan navigasi
class BuatKamuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              SizedBox(height: 60),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                  ),
                                  Text(
                                    "Dikirim ke ",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Jakarta Pusat",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 15,
                                  )
                                ],
                              ),
                              SizedBox(height: 40)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                  Positioned(
                    top: 90,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Menu(
                            "assets/icon/official-store.png",
                            label: "Official Store",
                          ),
                          Menu("assets/icon/lihat-semua.png",
                              label: "Lihat Semua"),
                          Menu("assets/icon/rumah-tangga.png",
                              label: "Rumah Tangga"),
                          Menu("assets/icon/topup.png",
                              label: "Top Up & Tagihan"),
                          Menu("assets/icon/elektronik.png",
                              label: "Elektronik"),
                          Menu("assets/icon/fashion.png",
                              label: "Fashion-Pria"),
                          Menu("assets/icon/keuangan.png", label: "Keuangan"),
                          Menu("assets/icon/travel.png", label: "Travel"),
                          Menu("assets/icon/komputer-dan-laptop.png",
                              label: "Komputer"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Menu("assets/icon2/bangga-lokal.png", label: "Bangga Lokal"),
                  Menu("assets/icon2/bazar-hari-ini.png",
                      label: "Bazar Hari Ini"),
                  Menu("assets/icon2/live-shopping.png",
                      label: "Live shopping"),
                  Menu("assets/icon2/belanja-harian.png",
                      label: "Belanja Harian"),
                  Menu("assets/icon2/bayar-ditempat.png",
                      label: "Bayar di Tempat"),
                ],
              ),
              SizedBox(height: 10),
              Sale(),
            ],
          ),
        ),
        Custom(),
      ],
    );
  }
}
