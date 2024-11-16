import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool isDriver;

  Header({required this.isDriver});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black), // Menu icon on left side
        onPressed: () {
          _showMenuOverlay(context);
        },
      ),
      actions: [
        IconButton(
          icon: Image.asset("assets/headerlogo.png"), // Logo on right side
          onPressed: () {
            // Handle logo tap if needed
          },
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the text in the middle
        children: [
          Text(
            "Bunch Free", // Text in white
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width, // Half-screen height
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black), // Close button
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile'); // Navigate to profile page
                },
                child: CircleAvatar(
                  radius: 70, // Increased size for the profile image
                  backgroundImage: AssetImage("assets/profile.jpg"), // Profile image
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Driver Name", // Display driver's name
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit Profile"),
                onTap: () {
                  Navigator.pushNamed(context, '/edit');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("Help"),
                onTap: () {
                  Navigator.pushNamed(context, '/help');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/login'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
