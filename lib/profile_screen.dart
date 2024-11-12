import 'package:flutter/material.dart';
import 'package:chatting_ui/edit_profile_screen.dart';
import 'package:chatting_ui/landing_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Boss Skibidi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: Text('Profile'),
  centerTitle: true,
  actions: <Widget>[
    PopupMenuButton<String>(
      onSelected: (String result) {
        switch (result) {
          case 'Edit Profile':
            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        name: name,
                        onSave: (updatedName) {
                          setState(() {
                            name = updatedName;
                          });
                        },
                      ),
                    ),
                  );
            break;
          case 'Log Out':
            showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
      //title: Text('Konfirmasi'),
      content: SingleChildScrollView(
          child: Center(
            child: Text.rich(
              TextSpan(
                text: '\nApakah kamu ingin ',
                style: TextStyle(fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: 'log out',
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
            Navigator.of(context).pop(); // Tutup dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LandingScreen()),
            );
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
            Navigator.of(context).pop(); // Tutup dialog
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
  break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Edit Profile',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Log Out',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
          ),
        ),
      ],
    ),
  ],
),
      body: Center(
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
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'skibidi@sigma.com',
              style: TextStyle(
                fontSize: 12,
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
                    'Department Name',
                    style: TextStyle(
                      fontSize: 20,
                   ),
                  ),
                  SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Company Owner',
                        style: TextStyle(
                          color: Color(0xFF23272A),
                          fontSize: 12,
                        ),
                      ),
                    ),  
                  SizedBox(height: 20),
                  Text(
                    'Your Role',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Owner',
                      style: TextStyle(
                        color: Color(0xFF23272A),
                        fontSize: 12,
                      ),
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