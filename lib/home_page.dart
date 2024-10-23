import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main/origin_screens/origin_cubao.dart';
import 'package:main/origin_screens/origin_dagupan.dart';

class HomePage extends StatelessWidget {
  final String userId; // Pass the user ID from login response

  HomePage({required this.userId});

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false, // Disable the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'User ID: $userId',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Optionally, add a logout function
                Navigator.pushReplacementNamed(context, '/login'); // Go back to the login screen
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icons/bg_new.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 0),
                  child: Image.asset(
                    'lib/icons/logo.png',
                    height: 100,
                    width: 150,
                  ),
                ),
                SizedBox(height: 0),
          
            Text(
              'SELECT YOUR ORIGIN:',
                style: GoogleFonts.montserrat( 
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            ),
            SizedBox(height: 10),


             // Space between text and buttons
            GestureDetector(
              onTap: () {
                // Add your functionality for Cubao
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CubaoOrigin("Your Origin String", userId: '',)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0), // Add padding around the image
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/icons/cubao.png', // Replace with your image path
                      height: 120, // Set the desired height for the image
                      width: 1000, // Set the desired width for the image
                    ),
                    SizedBox(height: 10), // Space between image and text
                  ],
                ),
              ),
            ),
            SizedBox(height: 0),

            
            // Space between buttons
            GestureDetector(
              onTap: () {
                // Add your functionality for Cubao
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DagupanOrigin('Dagupan')),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0), // Add padding around the image
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/icons/dagupan.png', // Replace with your image path
                      height: 120, // Set the desired height for the image
                      width: 1000, // Set the desired width for the image
                    ),
                    SizedBox(height: 10), // Space between image and text
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }

}
