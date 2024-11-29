import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/group_services.dart'; // Updated import

class GroupSettings extends StatefulWidget {
  final int groupId;

  const GroupSettings({super.key, required this.groupId});

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  bool _isInvitePopupVisible = false;
  bool _isKickMode = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _groupMembers = [];
  List<Map<String, dynamic>> _companyMembers = [];
  List<Map<String, dynamic>> _filteredCompanyMembers = [];
  List<Map<String, dynamic>> _selectedMembers = [];
  String _groupName = '';
  String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsImVtYWlsIjoibWFuYWdlckBnbWFpbC5jb20iLCJ0aXBlX3VzZXIiOiJtYW5hZ2VyIiwiaWF0IjoxNzMyODAyNDIyLCJleHAiOjE3MzI4ODg4MjJ9.zJaTDNAypqnoSBjfsQ18kQnbYc1mN98C12CaASJ6gBE';
  String tokenop = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiZW1haWwiOiJuZW9uZXR6QGdtYWlsLmNvbSIsInRpcGVfdXNlciI6Im9wZXJhdG9yIiwiaWF0IjoxNzMyODAyNDcwLCJleHAiOjE3MzI4ODg4NzB9.xPmOMNQXYZvERiTDrZfZpfjxmW8sCbcRp3S6YeY3jg4';
  @override
  void initState() {
    super.initState();
    _fetchGroupDetails();
    _fetchCompanyMembers();
    _searchController.addListener(_filterMembers);
  }

  Future<void> _fetchGroupDetails() async {
    final data = await GroupServices.fetchGroupDetails(widget.groupId);
    if (data != null) {
      setState(() {
        _groupName = data['name'];
        _groupMembers = List<Map<String, dynamic>>.from(data['users']);
      });
    } else {
      print('Failed to load group details');
    }
  }

  Future<void> _fetchCompanyMembers() async {
    final data = await GroupServices.fetchCompanyMembers();
    if (data != null) {
      setState(() {
        _companyMembers = List<Map<String, dynamic>>.from(data['data']);
        _filterMembers();
      });
    } else {
      print('Failed to load company members');
    }
  }

  void _filterMembers() {
    setState(() {
      _filteredCompanyMembers = _companyMembers
          .where((member) =>
              !_groupMembers.any((groupMember) => groupMember['id_users'] == member['id_users']) &&
              member['username']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _showInvitePopup() {
    setState(() {
      _isInvitePopupVisible = true;
    });
  }

  void _hideInvitePopup() {
    setState(() {
      _isInvitePopupVisible = false;
    });
  }

  void _toggleMemberSelection(Map<String, dynamic> member) {
    setState(() {
      if (_selectedMembers.contains(member)) {
        _selectedMembers.remove(member);
      } else {
        _selectedMembers.add(member);
      }
    });
  }

  void _toggleKickMode() {
    setState(() {
      _isKickMode = !_isKickMode;
    });
  }

  Future<void> _kickSelectedMembers() async {
    for (var member in _selectedMembers) {
      final success = await GroupServices.kickMember(widget.groupId, member['id_users']);
      if (success) {
        setState(() {
          _groupMembers.remove(member);
        });
      } else {
        print('Failed to kick member: ${member['username']}');
      }
    }
    _filterMembers();
    setState(() {
      _selectedMembers.clear();
      _isKickMode = false;
    });
  }

  Future<void> _inviteSelectedMembers() async {
    for (var member in _selectedMembers) {
      final success = await GroupServices.inviteMember(widget.groupId, member['id_users']);
      if (success) {
        setState(() {
          _groupMembers.add(member);
        });
      } else {
        print('Failed to invite member: ${member['username']}');
      }
    }
    _filterMembers();
    setState(() {
    _selectedMembers.clear();
    });
    _hideInvitePopup();
  }

  void _showKickConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: '\nApakah kamu ingin mengeluarkan ',
                  style: TextStyle(fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: '(${_selectedMembers.length}) member',
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
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _kickSelectedMembers();
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF606D75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 9),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Ya'),
                  SizedBox(width: 9),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF606D75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Tidak'),
                ],
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Group Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 70),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _groupName,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(height:50),
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Group Members',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _groupMembers.length, // Replace with the actual number of group members
                          itemBuilder: (context, index) {
                            final member = _groupMembers[index];
                            final isSelected = _selectedMembers.contains(member);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                member['username'],
                                style: TextStyle(
                                  color: isSelected ? Colors.grey : Colors.black,
                                ),
                              ),
                              trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
                              onTap: () {
                                if (_isKickMode) {
                                  _toggleMemberSelection(member);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isKickMode ? Colors.grey : Color(0xFF606D75),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _isKickMode ? null : _showInvitePopup,
                            child: Row(
                              children: [
                                Icon(Icons.person_add, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Invite Member',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 6),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF606D75),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _isKickMode
                                ? (_selectedMembers.isEmpty ? _toggleKickMode : _showKickConfirmationDialog)
                                : _toggleKickMode,
                            child: Row(
                              children: [
                                Icon(
                                  _isKickMode && _selectedMembers.isEmpty ? Icons.cancel : Icons.cancel,
                                  color: _isKickMode && _selectedMembers.isEmpty ? Colors.red : Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _isKickMode && _selectedMembers.isEmpty ? 'Cancel' : _isKickMode ? 'Confirm Kick' : 'Kick Member',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isInvitePopupVisible)
            GestureDetector(
              onTap: _hideInvitePopup,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 4,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Company Members',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search members...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredCompanyMembers.length,
                            itemBuilder: (context, index) {
                              final member = _filteredCompanyMembers[index];
                              final isSelected = _selectedMembers.contains(member);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  member['username'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.grey : Colors.black,
                                  ),
                                ),
                                trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
                                onTap: () {
                                  _toggleMemberSelection(member);
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF606D75),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _inviteSelectedMembers,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_add, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Invite Member',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

