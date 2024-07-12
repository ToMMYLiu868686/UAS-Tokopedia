import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tokopedia_ui/home/home_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> authenticateUser(BuildContext context) async {
      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('https://93dd-36-71-137-240.ngrok-free.app/api/auth'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );
        print(response.body);
        if (response.statusCode == 200 &&
            json.decode(response.body)['status']) {
          // Autentikasi berhasil
          Map<String, dynamic> userData = json.decode(response.body);
          int userId =
              userData['id']; // Sesuaikan dengan struktur respons dari API
          //jika status di 200++ maka data di respon body langsung pindah ke hal homepage dengan memberi user id
          //sesuai dengan respon API

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
            (route) => false,
          );
        } else {
          // Autentikasi gagal
          //jika hasil respon dari data body hasilnya false maka akan muncul popup email atau password salah
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email atau password salah'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat login'),
          ),
        );
      }
    }

//itu digunakan ketika kita tidak bisa terhubung ke server maka akan muncul popup (Catch)
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/produk/logo.jpg',
              height: 200,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  authenticateUser(context);
                },
                child: const Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
