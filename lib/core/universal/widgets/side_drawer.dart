import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

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
              "IOM Campus",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "Biggest Online Madrasha In Asia",
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

                _drawerItem(
                  icon: Icons.document_scanner_outlined,
                  text: "Manage Get Together",
                  onTap: () => Navigator.pop(context),
                ),

              ],
            ),
          ),

          // Bottom Logout
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: const Size(double.infinity, 48),
          //       backgroundColor: Colors.redAccent,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     icon: const Icon(Icons.logout, color: Colors.white),
          //     label: const Text(
          //       "Logout",
          //       style: TextStyle(fontSize: 16, color: Colors.white),
          //     ),
          //     onPressed: () {},
          //   ),
          // ),
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
