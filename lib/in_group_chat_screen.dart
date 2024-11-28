import 'package:flutter/material.dart';
import 'group_settings.dart';

class InGroupChatScreen extends StatefulWidget {
  final String groupName;
  final int groupId;

  const InGroupChatScreen({super.key, required this.groupName, required this.groupId});

  @override
  State<InGroupChatScreen> createState() => _InGroupChatScreenState();
}

class _InGroupChatScreenState extends State<InGroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Dummy data
  final List<Map<String, String>> _messages = [
    {
      "sender": "user222",
      "text": "Bangkonggggg",
      "time": "08:12 AM"
    },
    {
      "sender": "user222",
      "text": "usangggg",
      "time": "08:13 AM"
    },
    {
      "sender": "user456",
      "text": "Ya, kita akan membahas proyek minggu depan.",
      "time": "08:13 AM"
    },
    {
      "sender": "user123",
      "text": "Halo, ada yang di sini?",
      "time": "08:19 AM"
    },
    {
      "sender": "user789",
      "text": "Kabar baik, terima kasih!",
      "time": "08:22 AM"
    },
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          "sender": "You",
          "text": _messageController.text,
          "time": TimeOfDay.now().format(context),
        });
        _messageController.clear();
      });
    }
  }

  void _showLeaveGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            const SizedBox(width: 8),
            Text(
              widget.groupName,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              switch (value) {
                case 'Group Settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupSettings(groupId: widget.groupId)),
                  );
                  break;
                case 'leave_group':
                  _showLeaveGroupDialog();
                  break;
                case 'delete_group':
                  _showDeleteGroupDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Group Settings', // Perbaiki value di sini
                child: Text('Group Settings'),
              ),
              const PopupMenuItem(
                value: 'leave_group',
                child: Text('Leave Group'),
              ),
              const PopupMenuItem(
                value: 'delete_group',
                child: Text('Delete Group'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFD5E7EA),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isMe = message['sender'] == 'You';

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 12 : 0),
                          topRight: Radius.circular(isMe ? 0 : 12),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(
                              message['sender']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          Text(
                            message['text']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            message['time']!,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C3E50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
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
}
