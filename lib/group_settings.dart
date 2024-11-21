import 'package:flutter/material.dart';

class GroupSettings extends StatefulWidget {
  const GroupSettings({super.key});

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  bool _isInvitePopupVisible = false;
  bool _isKickMode = false;
  TextEditingController _searchController = TextEditingController();
  List<String> _companyMembers = List.generate(20, (index) => 'Company Member ${index + 1}');
  List<String> _filteredCompanyMembers = [];
  List<String> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _filteredCompanyMembers = _companyMembers;
    _searchController.addListener(_filterMembers);
  }

  void _filterMembers() {
    setState(() {
      _filteredCompanyMembers = _companyMembers
          .where((member) => member.toLowerCase().contains(_searchController.text.toLowerCase()))
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

  void _toggleMemberSelection(String member) {
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

  void _kickSelectedMembers() {
    setState(() {
      _companyMembers.removeWhere((member) => _selectedMembers.contains(member));
      _filteredCompanyMembers = _companyMembers;
      _selectedMembers.clear();
      _isKickMode = false;
    });
  }

  void _inviteSelectedMembers() {
    setState(() {
      _companyMembers.addAll(_selectedMembers);
      _filteredCompanyMembers = _companyMembers;
      _selectedMembers.clear();
      _hideInvitePopup();
    });
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
                SizedBox(height: 20),
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
                  'Project CorpaChat',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 100),
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 300,
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
                          itemCount: 20, // Replace with the actual number of group members
                          itemBuilder: (context, index) {
                            final member = 'Employee Freakbob ${index + 1}';
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
                                member,
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
                      Row(
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
                            onPressed: _isKickMode ? _showKickConfirmationDialog : _toggleKickMode,
                            child: Row(
                              children: [
                                Icon(Icons.cancel, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  _isKickMode ? 'Confirm Kick' : 'Kick Member',
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
                                  member,
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

