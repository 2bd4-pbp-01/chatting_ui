import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final String name;
  final Function(String) onSave;

  EditProfileScreen({required this.name, required this.onSave, required String email});

  @override
  Widget build(BuildContext context) {
    String updatedName = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Editing Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
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
                  '$name',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'skibidi@sigma.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width * 0.85,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 22,
                       ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          onChanged: (value) {
                          updatedName = value;
                          },
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            
            ),
            
          ),
          Positioned(
            bottom: 16,
            right: 16,
            
            child: ElevatedButton(
              onPressed: () {
                onSave(updatedName);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF606D75), // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              ),
              child: Text(
                'Save Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Helvetica Rounded',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}