import 'dart:convert'; // Import to decode JSON
import 'package:chatting_ui/helper/constant_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for date formatting
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
  List<Map<String, String>> _messages = []; // Store messages here

  // Fetch the messages from the API
  Future<void> _fetchMessages() async {
    final response = await http.get(
      Uri.parse(AppConstants.message + widget.groupName),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> messagesData = data['data'] as List<dynamic>;

      setState(() {
        _messages = messagesData.map((message) {
          final sender = message['senderId']?.toString() ?? 'Unknown';
          final text = message['text']?.toString() ?? 'No message';
          final timestamp = message['timestamp'] as int?;

          String formattedTime = 'Unknown time';
          if (timestamp != null) {
            final DateTime time =
            DateTime.fromMillisecondsSinceEpoch(timestamp);
            formattedTime = DateFormat('HH:mm').format(time);
          }

          return {
            'sender': sender,
            'text': text,
            'time': formattedTime,
          };
        }).toList();
      });
    } else {
      print('Failed to load messages. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch messages when the screen is initialized
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final String messageText = _messageController.text;

      // Clear the input field and update local messages list
      setState(() {
        _messages.add({
          'sender': 'You',
          'text': messageText,
          'time': TimeOfDay.now().format(context),
        });
        _messageController.clear();
      });

      // Prepare the payload for the API
      final Map<String, dynamic> payload = {
        'senderId': 'You', // Replace with actual senderId if available
        'text': messageText,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      try {
        final response = await http.post(
          Uri.parse(AppConstants.message + widget.groupName),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        if (response.statusCode == 200) {
          print('Message sent successfully');
        } else {
          print('Failed to send message. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error while sending message: $e');
      }
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
        content: const Text(
            'Are you sure you want to delete this group? This action cannot be undone.'),
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
              'Group ${widget.groupName}',
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
                value: 'Group Settings',
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isMe = message['sender'] == 'You';

                  return Align(
                    alignment:
                    isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 12 : 0),
                          topRight: Radius.circular(isMe ? 0 : 12),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
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
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
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
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                      child: const Icon(Icons.send,
                          color: Colors.white, size: 20),
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
