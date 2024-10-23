import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SeatSelectionScreen extends StatefulWidget {
  final String userId;
  final String busTicketId;
  final String serviceClass; // New parameter for service class
  final String busNumber; // New parameter for bus number
  final String fare; // New parameter for fare
  final String departure; // New parameter for departure
  final String tripDuration; // New parameter for trip duration
  final String availableSeats; // New parameter for available seats

  const SeatSelectionScreen({
    Key? key,
    required this.userId,
    required this.busTicketId,
    required this.serviceClass,
    required this.busNumber,
    required this.fare,
    required this.departure,
    required this.tripDuration,
    required this.availableSeats, required busTicketData,
  }) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Set<String> selectedSeats = {};
  String userData = ''; // To hold the user data
  String busTicketData = ''; // To hold the bus ticket data
  bool isLoading = true; // To show loading while fetching data

  @override
  void initState() {
    super.initState();
    if (widget.userId.isNotEmpty && widget.busTicketId.isNotEmpty) {
      fetchUserData(); // Fetch user data if userId is provided
      fetchBusTicketData(); // Fetch bus ticket data
    } else {
      setState(() {
        isLoading = false; // Stop loading if userId or busTicketId is not valid
      });
    }
  }

  Future<void> reserveSeats() async {
  var url = 'http://192.168.100.185/bbydb/reserveSeats.php';
  var response = await http.post(
    Uri.parse(url),
    body: {
      'userId': widget.userId,
      'busTicketId': widget.busTicketId,
      'seats': selectedSeats.join(','), // Send selected seats as a comma-separated string
      'service_class': widget.serviceClass, // New field
      'bus_number': widget.busNumber, // New field
      'fare': widget.fare, // New field
      'departure': widget.departure, // New field
      'trip_duration': widget.tripDuration, // New field
      'available_seats': widget.availableSeats, // New field
    },
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seats reserved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation failed: ${data['message']}')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to reserve seats.')),
    );
  }
}


  Future<void> fetchBusTicketData() async {
    var url = 'http://192.168.100.185/bbydb/getBusTicketData.php?ticketId=${widget.busTicketId}';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data.containsKey('ticket_info')) {
          busTicketData = 'Bus Ticket ID: ${data['ticket_info']['id']}'; // Adjust based on your API response structure
        } else {
          busTicketData = 'Error: ${data['error']}'; // Log API error if present
        }

        setState(() {
          isLoading = false; // Data fetched, stop loading
        });
      } else {
        setState(() {
          busTicketData = 'Failed to load bus ticket data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        busTicketData = 'Error fetching bus ticket data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserData() async {
    var url = 'http://192.168.100.185/bbydb/getUserData.php?userId=${widget.userId}';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['user_info'] is Map) {
          userData = 'User Email: ${data['user_info']['email']}'; // Fetch and display user's email or other details
        } else {
          userData = data['user_info'].toString(); // In case user_info is not a map, display raw data
        }

        setState(() {
          isLoading = false; // Data fetched, stop loading
        });
      } else {
        setState(() {
          userData = 'Failed to load user data. Status code: ${response.statusCode}';
          isLoading = false; // Error occurred, stop loading
        });
      }
    } catch (e) {
      setState(() {
        userData = 'Error fetching user data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'lib/icons/bg_new.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(0, 194, 194, 194).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 50,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Available Seats',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Segoe UI',
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      
                      // Seat selection UI for rows 1 to 10 (4 seats per row)
                      for (int i = 1; i <= 10; i++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int j = 0; j < 2; j++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      String seatId = '${String.fromCharCode(65 + j)}$i';
                                      if (selectedSeats.contains(seatId)) {
                                        selectedSeats.remove(seatId);
                                      } else {
                                        selectedSeats.add(seatId);
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      color: selectedSeats.contains('${String.fromCharCode(65 + j)}$i')
                                          ? Colors.green
                                          : Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0),
                                      ),
                                    ),
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        '${String.fromCharCode(65 + j)}$i',
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 60),
                              for (int j = 2; j < 4; j++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      String seatId = '${String.fromCharCode(67 + (j - 2))}$i';
                                      if (selectedSeats.contains(seatId)) {
                                        selectedSeats.remove(seatId);
                                      } else {
                                        selectedSeats.add(seatId);
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      color: selectedSeats.contains('${String.fromCharCode(67 + (j - 2))}$i')
                                          ? Colors.green
                                          : Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0),
                                      ),
                                    ),
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        '${String.fromCharCode(67 + (j - 2))}$i',
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      // Seat selection UI for row 11 (5 seats)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 5; j++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    String seatId = 'E${j + 1}';
                                    if (selectedSeats.contains(seatId)) {
                                      selectedSeats.remove(seatId);
                                    } else {
                                      selectedSeats.add(seatId);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: selectedSeats.contains('E${j + 1}')
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  width: 60,
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      'E${j + 1}',
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User Info:  ${widget.userId}'),
                Text('Bus Ticket Info: $busTicketData'),
                Text('Bus Number: ${widget.busNumber}'),
                Text('Service Class: ${widget.serviceClass}'),
                Text('Fare: ${widget.fare}'),
                Text('Departure: ${widget.departure}'),
                Text('Trip Duration: ${widget.tripDuration}'),
                Text('Available Seats: ${widget.availableSeats}'),
              ],
            ),
          ),
              ElevatedButton(
                onPressed: reserveSeats,
                child: const Text('Reserve Seats'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//TIMESTAMP - pleaseee mag fetch ka na baoninaaaaa