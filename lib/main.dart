// lib/main.dart
import 'package:flutter/material.dart';
import 'package:iom_campus_app/core/local_storage/user_info.dart';
import 'package:iom_campus_app/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize UserInfo (SharedPreferences)
  await UserInfo().init();

  // Request permissions
  await _requestPermissions();

  runApp(const CampusApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();
}

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Campus App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}