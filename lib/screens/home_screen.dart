// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:iom_campus_app/core/local_storage/user_info.dart';
import 'package:iom_campus_app/screens/webview_screen.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<WebViewScreen> _screens = [
    const WebViewScreen(
      url: 'https://campus.iom.edu.bd/', // Replace with your campus website URL
      title: 'Campus',
      key: ValueKey('app'),
    ),
    const WebViewScreen(
      url: 'https://portal.iom.edu.bd/', // Replace with your student portal URL
      title: 'Student Portal',
      key: ValueKey('portal'),
    ),
  ];

  @override
  Widget build(BuildContext context) {

    print('User is logged in: ${UserInfo().isLoggedIn}');

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Campus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Student Portal',
          ),
        ],
      ),
    );
  }
}