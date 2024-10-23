import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:main/home_page.dart';
import 'package:main/ticket_screens/ticket_dashboard.dart';
// Import your TicketDashboard class

class DagupanOrigin extends StatelessWidget {
  final String origin;

  DagupanOrigin(this.origin);

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
          children: [
            // Row to align back button and logo horizontally
            Row(
              children: [
                // Back Button with left padding
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 19.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(userId: '',)), // Navigate to NewPage
                      );
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                // Logo with top padding
                SizedBox(width: 70),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    'lib/icons/logo.png',
                    height: 100,
                    width: 150,
                  ),
                ),
              ],
            ),
            Spacer(), // Spacer to push the buttons to the bottom
            // Row for the bottom buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home Button
                Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 0, 0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.home,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 20,
                    ),
                    onPressed: () {
                      // Handle home button press
                    },
                  ),
                ),
                SizedBox(width: 0),
                // Ticket Button
                Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      bottomLeft: Radius.zero,
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.ticketAlt,
                      color: const Color.fromARGB(255, 237, 0, 0),
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicketDashboard(userId: '',)), // Navigate to TicketDashboard
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//timestamp - maayos
