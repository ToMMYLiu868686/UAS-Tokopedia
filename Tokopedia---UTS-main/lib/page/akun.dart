import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tokopedia_ui/home/authscreen.dart';
import 'dart:convert';
import 'package:tokopedia_ui/store.dart';

//untuk manggil akun.dart kita harus menggunakan user.id agar bisa memanggil sesuai yg diminta melalui API
class AkunPage extends StatefulWidget {
  final int userId;
  const AkunPage({super.key, required this.userId});

  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  late Future<Map<String, dynamic>> _userDetails;

  @override
  void initState() {
    super.initState();
    _userDetails = fetchUserDetails();
  }

// untuk mengambil detail user ketika direload atau dibuka untuk mengambil data dari API
  Future<Map<String, dynamic>> fetchUserDetails() async {
    String id = widget.userId.toString();
    final response = await http.get(
        Uri.parse('https://93dd-36-71-137-240.ngrok-free.app/api/users/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user details');
    }
  }

// untuk menrefresh halaman
  Future<void> _refreshUserDetails() async {
    setState(() {
      _userDetails = fetchUserDetails();
    });
  }

//untuk design on off toggle notif tadi dimana ketika user ingin data diganti maka data akan langsung dikirim dan direfresh pada API
  void _toggleNotification(bool newValue) async {
    final userDetails = await _userDetails;
    final userId = userDetails['id'];

    final response = await http.put(
      Uri.parse('https://93dd-36-71-137-240.ngrok-free.app/api/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'notif': newValue ? 'aktif' : 'mati',
      }),
    );
    if (response.statusCode == 201) {
      _refreshUserDetails();
    } else {
      print('Failed to update notification status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Saya'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshUserDetails,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user[
                              'foto']), // Replace with actual profile picture URL
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['nama'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user['email'],
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profil Saya'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(user: user)),
                        ).then((_) {
                          _refreshUserDetails();
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifikasi'),
                      trailing: Switch(
                        value: user['notif'] == 'aktif',
                        onChanged: (newValue) {
                          _toggleNotification(newValue);
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text('Keamanan'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KeamananPage(user: user)),
                        ).then((_) {
                          _refreshUserDetails();
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Bantuan'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Bantuan'),
                              content: Text('Ini adalah halaman bantuan.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Keluar'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthScreen()),
                            (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['nama']);
    _addressController = TextEditingController(text: widget.user['alamat']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final response = await http.put(
      Uri.parse(
          'https://93dd-36-71-137-240.ngrok-free.app/api/users/${widget.user['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nama': _nameController.text,
        'alamat': _addressController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Close edit profile page
    } else {
      print('Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}

class KeamananPage extends StatefulWidget {
  final Map<String, dynamic> user;

  KeamananPage({required this.user});

  @override
  _KeamananPageState createState() => _KeamananPageState();
}

class _KeamananPageState extends State<KeamananPage> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.user['notif'] == 'aktif';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keamanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Ganti Password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GantiPasswordPage(user: widget.user)),
                ).then((_) {
                  // Handle password change success
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GantiPasswordPage extends StatefulWidget {
  final Map<String, dynamic> user;

  GantiPasswordPage({required this.user});

  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final response = await http.put(
      Uri.parse(
          'https://93dd-36-71-137-240.ngrok-free.app/api/users/${widget.user['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'password': _newPasswordController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Close change password page
    } else {
      print('Failed to update password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password Saat Ini'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password Baru'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
