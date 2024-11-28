import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chatting_ui/services/auth_services.dart';
import 'creategroup.dart';
import 'departement_settings.dart';
import 'profile_screen.dart';
import 'in_group_chat_screen.dart';

// Model untuk grup
class GroupItem {
  final int idGroup;
  final String name;

  GroupItem({required this.idGroup, required this.name});

  factory GroupItem.fromJson(Map<String, dynamic> json) {
    return GroupItem(
      idGroup: json['id_group'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<GroupItem>> groupList;

  // Fungsi untuk mengambil data grup dari AuthService
  Future<List<GroupItem>> fetchGroups() async {
    try {
      final List groups = await AuthService.getGroups();
      // Parsing data ke dalam model GroupItem
      return groups.map((json) => GroupItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load groups: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    groupList = fetchGroups(); // Memanggil fungsi untuk mengambil data grup
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF2C3E50),
          title: const Text(
            'IT Department',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (String choice) {
                switch (choice) {
                  case 'Department Settings':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DepartmentSettingsScreen(),
                      ),
                    );
                    break;
                  case 'Profile':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                    break;
                  case 'Create Group':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateGroupScreen(
                          refreshGroups: () {
                            setState(() {
                              groupList = fetchGroups(); // Memuat ulang grup
                            });
                          },
                        ),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Department Settings',
                  child: Row(
                    children: [
                      const Icon(Icons.corporate_fare, color: Colors.black87),
                      const SizedBox(width: 10),
                      const Text('Department Settings'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.black87),
                      const SizedBox(width: 10),
                      const Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Create Group',
                  child: Row(
                    children: [
                      const Icon(Icons.group_add, color: Colors.black87),
                      const SizedBox(width: 10),
                      const Text('Create Group'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: const Color(0xFF2C3E50),
              child: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Groups', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Tab(child: Text('Chats', style: TextStyle(color: Colors.white))),
                  const Tab(child: Text('Notes', style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ),
        ),
        body: FutureBuilder<List<GroupItem>>(
          future: groupList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final groups = snapshot.data!;
              return TabBarView(
                children: [
                  ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return GroupListTile(group: groups[index]);
                    },
                  ),
                  const Center(child: Text('Chats Content')),
                  const Center(child: Text('Notes Content')),
                ],
              );
            } else {
              return const Center(child: Text('No groups found.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF2C3E50),
          child: const Icon(Icons.message, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }
}


class GroupListTile extends StatelessWidget {
  final GroupItem group;

  const GroupListTile({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        group.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Group ID: ${group.idGroup}'),
      onTap: () {
        // Navigasi ke layar obrolan grup
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InGroupChatScreen(groupName: group.name),
          ),
        );
      },
    );
  }
}
