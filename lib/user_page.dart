import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:main/login_page.dart';

class UserPage extends StatefulWidget {
  final String userId;

  const UserPage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _isLoading = false; // To track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${widget.userId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User details will be displayed here.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _logout(context), // Disable button when loading
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Logout'),
            ),
            if (_isLoading) // Show loading indicator
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    print('Logout button pressed'); // Debugging line

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    // Clear user data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Check if userId exists before removing
    bool userExists = prefs.containsKey('userId');
    print('User ID exists: $userExists'); // Debugging line

    if (userExists) {
      await prefs.remove('userId'); // Clear userId
      print('User ID removed'); // Debugging line
    } else {
      print('No user ID found to remove'); // Debugging line
    }

    // Navigate to the login page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all previous routes
    );

    setState(() {
      _isLoading = false; // Reset loading state
    });
  }
}


//timestamp - nakakalogout na