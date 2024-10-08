import 'package:flutter/material.dart';
import 'package:client/widgets/SearchCategory.dart';
import 'package:client/screens/ProfileScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:client/screens/OcrScreen.dart';
import 'package:client/screens/HomeScreen.dart';
import 'package:client/screens/RecommendScreen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const RecommendationScreen(),
    const OcrScreen(),
    const SearchCategory(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Set the background color for better visibility
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              spreadRadius: 1.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GNav(
            onTabChange: (index) => _onItemTapped(index),
            activeColor: Colors.white,
            color: Colors.purple,
            tabBackgroundColor: Colors.purple, // Background color of active tab
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.receipt,
                text: 'Recomm',
              ),
              GButton(
                icon: Icons.camera,
                text: "OCR",
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
