import 'package:flutter/material.dart';

class DepartmentSettingsScreen extends StatelessWidget {
  const DepartmentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Settings'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Department Name'),
            subtitle: const Text('IT Department'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Implementasi edit department name
              },
            ),
          ),
          ListTile(
            title: const Text('Department Members'),
            trailing: IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                // Tampilkan daftar anggota
              },
            ),
          ),
          ListTile(
            title: const Text('Department Permissions'),
            trailing: IconButton(
              icon: const Icon(Icons.security),
              onPressed: () {
                // Atur permissions
              },
            ),
          ),
        ],
      ),
    );
  }
}
