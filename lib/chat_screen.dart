import 'package:flutter/material.dart';
import 'departement_settings.dart';
import 'profile_screen.dart';
import 'creategroup.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ProjectItem> projects = [
    ProjectItem(
      title: 'Project CorpsChat',
      subtitle: "Let's Meet",
      time: '11:48',
      notificationCount: 123,
      imageUrl: 'placeholder_url',
    ),
    ProjectItem(
      title: 'Project Gacor',
      subtitle: "Yes, That's correct!",
      time: '09:21',
      imageUrl: 'placeholder_url',
    ),
    ProjectItem(
      title: 'Project MEme',
      subtitle: "Yes, That's correct!",
      time: '09:21',
      imageUrl: 'placeholder_url',
    ),
    ProjectItem(
      title: 'Project META',
      subtitle: "Yes, That's correct!",
      time: '09:21',
      imageUrl: 'placeholder_url',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Menghapus tombol back
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
                        builder: (context) => CreateGroupScreen(),
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
                        const Text('Groups',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Tab(
                    child: Text('Chats', style: TextStyle(color: Colors.white)),
                  ),
                  const Tab(
                    child: Text('Notes', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Projects Tab
            ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return ProjectListTile(project: projects[index]);
              },
            ),
            // Chats Tab
            const Center(child: Text('Chats Content')),
            // Notes Tab
            const Center(child: Text('Notes Content')),
          ],
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

class ProjectItem {
  final String title;
  final String subtitle;
  final String time;
  final int? notificationCount;
  final String imageUrl;

  ProjectItem({
    required this.title,
    required this.subtitle,
    required this.time,
    this.notificationCount,
    required this.imageUrl,
  });
}

class ProjectListTile extends StatelessWidget {
  final ProjectItem project;

  const ProjectListTile({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person), // Placeholder for actual image
      ),
      title: Text(
        project.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        project.subtitle,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            project.time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          if (project.notificationCount != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                project.notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
