import 'package:flutter/material.dart';
import 'package:tokopedia_ui/home/widget/produk.dart';
import 'package:tokopedia_ui/home/widget/waktu.dart';

class Sale extends StatelessWidget {
  const Sale({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            //Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Traktiran Pengguna Baru",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Berakhir dalam:",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              // Waktu(),
                            ],
                          ),
                        )),
                    Spacer(),
                    Text(
                      "Lihat semua",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
            //Items
            SizedBox(height: 10),
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.green,
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      height: 230,
                      width: 120,
                    ),
                    Produk(),
                    Produk(),
                    Produk(),
                    Produk(),
                    Produk(),
                    Produk(),
                    Produk(),
                    Produk(),
                    Produk(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
