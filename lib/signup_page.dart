import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:main/login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '', fullname = '', email = '', password = '', confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _obscureText = true;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      // Save the current form state
      _formKey.currentState!.save();

      // Check if passwords match
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
        return;  // Do not proceed if passwords do not match
      }

      var url = 'http://192.168.100.185/bbydb/signup.php';
      var response = await http.post(Uri.parse(url), body: {
        'username': username,
        'fullname': fullname,
        'email': email,
        'password': password,
      });

      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Clear the text fields since registration is successful
        _formKey.currentState!.reset();
        username = '';
        fullname = '';
        email = '';
        password = '';
        confirmPassword = '';

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered successfully")));

        // Navigate to the login page after a brief delay
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // Show error message from server response
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
        // Do not clear the text fields if registration fails
      }
    } else {
      // Show a message if any field is not filled properly
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields correctly.")));
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icons/bg_new.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // Enable scrolling
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset(
                    'lib/icons/logo_new.png', // Logo image
                    height: 250,
                  ),
                ),

                // White container for text
                Container(
                  width: double.infinity, // Occupy full width
                  height: MediaQuery.of(context).size.height * 0.63, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Slightly transparent white
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Padding inside the container
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sign Up text
                          const Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: 'GabrielSans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Username text field
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: const TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(149, 64, 47, 14),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 0.0),
                                child: Icon(
                                  Icons.person,
                                  color: Color.fromRGBO(169, 113, 0, 1),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              fillColor: const Color.fromARGB(255, 255, 223, 169),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                            ),
                            onSaved: (value) => username = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Fullname text field
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              hintStyle: const TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(149, 64, 47, 14),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 0.0),
                                child: Icon(
                                  Icons.person,
                                  color: Color.fromRGBO(169, 113, 0, 1),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              fillColor: const Color.fromARGB(255, 255, 223, 169),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                            ),
                            onSaved: (value) => fullname = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Email text field
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: const TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(149, 64, 47, 14),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 0.0),
                                child: Icon(
                                  Icons.email,
                                  color: Color.fromRGBO(169, 113, 0, 1),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              fillColor: const Color.fromARGB(255, 255, 223, 169),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                            ),
                            onSaved: (value) => email = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Password text field
                          TextFormField(
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(149, 64, 47, 14),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 0.0),
                                child: Icon(
                                  Icons.lock,
                                  color: Color.fromRGBO(169, 113, 0, 1),
                                ),
                              ),
                              
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: Color.fromRGBO(169, 113, 0, 0.28),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              fillColor: const Color.fromARGB(255, 255, 223, 169),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                            ),
                            onSaved: (value) => password = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Confirm Password text field
                          TextFormField(
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: const TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(149, 64, 47, 14),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 0.0),
                                child: Icon(
                                  Icons.lock,
                                  color: Color.fromRGBO(169, 113, 0, 1),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: Color.fromRGBO(169, 113, 0, 0.28),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 223, 169)),
                              ),
                              fillColor: const Color.fromARGB(255, 255, 223, 169),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                            ),
                            onSaved: (value) => confirmPassword = value!,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Sign Up button
                          Container(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _signup,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                backgroundColor: const Color.fromARGB(255, 236, 33, 40),
                                minimumSize: const Size(350, 0), // Set the minimum width to 350, height will adapt
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Sign in text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
