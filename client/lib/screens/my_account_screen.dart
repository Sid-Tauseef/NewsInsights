import 'package:client/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Add shared_preferences for token storage

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String? username;
  String? email;
  String? phone;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail =
        prefs.getString('email'); // Retrieve the email from shared preferences

    if (userEmail != null) {
      try {
        // Send a POST request to the backend with the user's email
        final response = await http.post(
          Uri.parse(
              '${Config.getUserDetails}/'), // Ensure you point to the right endpoint
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': userEmail, // Send the user's email
          }),
        );

        if (response.statusCode == 200) {
          // Decode the response and update the state
          final Map<String, dynamic> data = jsonDecode(response.body)['data'];
          setState(() {
            username = data['username'];
            email = data['email'];
            phone = data['phone'];
          });
        } else {
          throw Exception('Failed to load user data');
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("No user email found in shared preferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.purple),
              title: const Text(
                'Username',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                username ?? 'Loading...', // Display username dynamically
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.purple),
              title: const Text(
                'Email',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                email ?? 'Loading...', // Display email dynamically
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.purple),
              title: const Text(
                'Phone Number',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                phone ?? 'Loading...', // Display phone number dynamically
              ),
            ),
            const Divider(),
            const SizedBox(height: 40.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic for editing account information can be added here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Edit Account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
