import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SeatSelection extends StatefulWidget {
  final String userId; // User ID
  final Map ticket; // Ticket data

  SeatSelection({required this.userId, required this.ticket, required Map ticketDetails});

  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  List<String> selectedSeats = [];
  List<String> reservedSeats = []; // List to hold reserved seats

  @override
  void initState() {
    super.initState();
    // Fetch reserved seats when the widget is initialized
    fetchReservedSeats().then((seats) {
      setState(() {
        reservedSeats = seats;
      });
    }).catchError((error) {
      print('Error fetching reserved seats: $error');
    });
  }

  // Function to fetch reserved seats from the API
  Future<List<String>> fetchReservedSeats() async {
    final response = await http.post(
      Uri.parse('http://192.168.100.185/bbydb/fetch_reserved_seats.php'), // Adjust URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'busNumber': widget.ticket['bus_number'],
        'departure': widget.ticket['departure'],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<String>.from(responseData['reservedSeats']); // List of reserved seats
    } else {
      throw Exception('Failed to load reserved seats');
    }
  }

  // Function to reserve seats
  Future<void> reserveSeats() async {
    // Prepare the reservation data
    final reservationData = {
      'userId': widget.userId,
      'terminal': widget.ticket['terminal'],
      'destination': widget.ticket['destination'],
      'busNumber': widget.ticket['bus_number'],
      'departure': widget.ticket['departure'],
      'serviceClass': widget.ticket['service_class'],
      'seats': selectedSeats,
      'totalFare': (double.tryParse(widget.ticket['base_fare'].toString()) ?? 0.0) * selectedSeats.length,
    };

    // Send reservation data to the PHP API
    final response = await http.post(
      Uri.parse('http://192.168.100.185/bbydb/seatreservation.php'), // Change to your API URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reservationData),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );

      // Update reservedSeats
      setState(() {
        reservedSeats.addAll(selectedSeats); // Add selected seats to reserved seats
      });

      // Clear selected seats after reservation
      setState(() {
        selectedSeats.clear();
      });

      // Close the modal
      Navigator.pop(context);
    } else {
      // Show error message
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${responseData['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime departureDateTime = DateTime.parse(widget.ticket['departure']);
    String formattedDeparture = DateFormat('h:mma - MMMM d, y').format(departureDateTime);

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
            'lib/icons/bg_new.png', // Ensure this path is correct
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
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
                    'AVAILABLE SEATS',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Segoe UI',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Seat selection UI
                    for (int i = 1; i <= 10; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 2; j++)
                              buildSeat('${String.fromCharCode(65 + j)}$i'),
                            const SizedBox(width: 60),
                            for (int j = 2; j < 4; j++)
                              buildSeat('${String.fromCharCode(67 + (j - 2))}$i'),
                          ],
                        ),
                      ),
                    // Additional row with 5 seats at the back (row E)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int j = 0; j < 5; j++)
                            buildSeat('E${j + 1}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Reserve Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 237, 0, 0), // Set the background color to red
                  ),
                  onPressed: () {
                    // Show modal with user ID, bus details, and selected seats
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          height: 400,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.ticket['terminal']} → ${widget.ticket['destination']}',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Service Class: ',
                                  style: TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${widget.ticket['service_class']}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Bus Number: ',
                                  style: TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${widget.ticket['bus_number']}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Total Fare: ₱ ',
                                  style: TextStyle(fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${(double.tryParse(widget.ticket['base_fare'].toString()) ?? 0.0) * selectedSeats.length}',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Departure Time: $formattedDeparture',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Selected Seats:',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8.0,
                                children: selectedSeats
                                    .map((seat) => Chip(
                                          label: Text(seat),
                                          backgroundColor: Colors.green,
                                          labelStyle: const TextStyle(color: Colors.white),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  await reserveSeats(); // Call the reservation function
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 237, 0, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Confirm Reservation'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Proceed to Reserve',
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
            
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build seat widgets
  Widget buildSeat(String seatId) {
    return GestureDetector(
      onTap: reservedSeats.contains(seatId) ? null : () {
        setState(() {
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
          color: reservedSeats.contains(seatId)
              ? Colors.grey // Reserved seats in grey
              : selectedSeats.contains(seatId)
                  ? Colors.green // Selected seats in green
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
            seatId,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
