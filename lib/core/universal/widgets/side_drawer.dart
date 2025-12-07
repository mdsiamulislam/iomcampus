import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iom_campus_app/core/local_storage/user_info.dart';
import 'package:iom_campus_app/feature/auth/pages/admin_verification_screen.dart';
import 'package:iom_campus_app/feature/geto/pages/scan_screen.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  void _checkAdminStatus() {
    setState(() {
      isAdmin = UserInfo().isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12,
      child: Column(
        children: [
          // Top Profile Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.school,
                size: 40,
                color: Colors.green,
              ),
            ),
            accountName: Text(
              isAdmin ? UserInfo().name : "IOM Campus",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              isAdmin ? UserInfo().email : "Biggest Online Madrasha In Asia",
              style: TextStyle(fontSize: 13),
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: Icons.home_outlined,
                  text: "Home",
                  onTap: () => Navigator.pop(context),
                ),

                // Show only if admin
                if (isAdmin)
                  _drawerItem(
                    icon: Icons.document_scanner_outlined,
                    text: "Manage Get Together",
                    onTap: () {
                      Get.to(() => ScanScreen());
                    },
                  ),
              ],
            ),
          ),

          // Bottom Button (Join or Logout)
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: isAdmin ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                isAdmin ? Icons.logout : Icons.login,
                color: Colors.white,
              ),
              label: Text(
                isAdmin ? "Logout" : "Join As Administrator",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () async {
                if (isAdmin) {
                  // Logout
                  await UserInfo().clearUser();
                  setState(() {
                    isAdmin = false;
                  });
                  Get.snackbar(
                    "Logged Out",
                    "You have been logged out successfully",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  // Navigate to Admin Verification
                  final result = await Get.to(() => AdminVerificationScreen());
                  // Refresh admin status when coming back
                  if (result == true || mounted) {
                    _checkAdminStatus();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Builder
  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.green.shade700),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 12,
    );
  }
}