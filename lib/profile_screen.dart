import 'dart:convert';

import 'package:chatting_ui/services/auth_services.dart';
import 'package:chatting_ui/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'edit_profile_screen.dart';
import 'landing_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String? name;
  String? email;
  String? role;
  bool isLoading = true;

  final ProfileServices _profileServices = ProfileServices();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final username = await _storage.read(key: 'username');
      final email = await _storage.read(key: 'email');
      final tipeUser = await _storage.read(key: 'tipe_user');

      // Debug log
      print("userDataJson: $username");

      setState(() {
        name = username ?? 'Unknown';
        this.email = email ?? 'Unknown'; // Hindari konflik nama variabel
        role = tipeUser ?? 'Unknown';
        isLoading = false;
      });
    } catch (e) {
      // Log error jika perlu
      print("Error loading user data: $e");

      setState(() {
        name = 'Error';
        email = 'Error';
        role = 'Error';
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Edit Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        name: name ?? '',
                        email: email ?? '',
                        onSave: (updatedName) {
                          setState(() {
                            name = updatedName;
                          });
                        },
                      ),
                    ),
                  );
                  break;
                case 'Log Out':
                  _showLogoutDialog(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Edit Profile',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Log Out',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name ?? 'Unknown',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 5),
            Text(
              email ?? 'Unknown',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 4,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Role',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      role ?? 'Unknown',
                      style: const TextStyle(color: Color(0xFF23272A)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: '\nApakah kamu ingin ',
                  style: TextStyle(fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'log out',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '?'),
                  ],
                ),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Navigator.of(context).pop();
                await AuthService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingScreen()),
                      (route) => false,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF606D75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 9),
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Ya'),
                  SizedBox(width: 9),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF606D75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.close, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Tidak'),
                ],
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        );
      },
    );
  }
}
