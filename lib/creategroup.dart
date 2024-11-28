import 'package:flutter/material.dart';
import 'package:chatting_ui/services/auth_services.dart';
import 'package:chatting_ui/chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  final Function refreshGroups;

  const CreateGroupScreen({super.key, required this.refreshGroups});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> createGroup() async {
    final groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group name cannot be empty!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Kirim permintaan untuk membuat grup
      final result = await AuthService.createGroup(
        groupName: groupName,
      );

      setState(() {
        _isLoading = false;
      });

      print('Create Group Result: $result'); // Debugging

      if (result['success']) {
        // Panggil fungsi refresh groups yang diteruskan dari ChatScreen
        widget.refreshGroups();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Group created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke layar sebelumnya
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to create group'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error in createGroup: $e'); // Debugging

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating group: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Create Group', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Group Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: createGroup,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2C3E50)),
                      child: const Text('Create Group'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
