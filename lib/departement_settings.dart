import 'package:flutter/material.dart';

class DepartmentSettingsScreen extends StatefulWidget {
  const DepartmentSettingsScreen({super.key});

  @override
  State<DepartmentSettingsScreen> createState() => _DepartmentSettingsScreenState();
}

class _DepartmentSettingsScreenState extends State<DepartmentSettingsScreen> {
  final List<String> _members = ['User123', 'User456', 'User789']; // Dummy data anggota
  final TextEditingController _addMemberController = TextEditingController();

  void _addMember() {
    if (_addMemberController.text.isNotEmpty) {
      setState(() {
        _members.add(_addMemberController.text);
        _addMemberController.clear();
      });
    }
  }

  void _kickMember(String member) {
    setState(() {
      _members.remove(member);
    });
  }

  void _saveSettings() {
    // Implementasi logika penyimpanan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved!')),
    );
  }

  @override
  void dispose() {
    _addMemberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna appbar putih
        elevation: 1, // Tambahkan bayangan ringan
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Tombol back hitam
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Department Settings',
          style: TextStyle(color: Colors.black), // Teks hitam
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Department Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return ListTile(
                    title: Text(member),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _kickMember(member),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addMemberController,
                    decoration: InputDecoration(
                      hintText: 'Add new member',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: const Color(0xFF2C3E50), // Warna tombol "Save Settings"
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
