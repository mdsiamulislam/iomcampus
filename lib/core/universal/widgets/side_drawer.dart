import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iom_campus_app/core/local_storage/user_info.dart';
import 'package:iom_campus_app/screens/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
    isAdmin = UserInfo().isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 12,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade700],
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.school, size: 38, color: Colors.green),
            ),
            accountName: Text(
              isAdmin ? UserInfo().name : "IOM Campus",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              isAdmin
                  ? UserInfo().email
                  : "Biggest Online Madrasha In Asia",
              style: const TextStyle(fontSize: 13),
            ),
          ),

          /// Academic Section
          _sectionTitle("Academic"),
          _drawerItem(
            icon: Icons.school_outlined,
            text: "IOM Main Website",
            url: "https://iom.edu.bd/",
          ),

          const Divider(),

          /// Others Section
          _sectionTitle("Others & Services"),
          _drawerItem(
            icon: Icons.shopping_bag_outlined,
            text: "Hadia Shop",
            url: "https://shop.iom.edu.bd/",
          ),
          _drawerItem(
            icon: Icons.menu_book_outlined,
            text: "E-Library",
            url: "https://elibrary.iom.edu.bd/",
          ),
          _drawerItem(
            icon: Icons.question_answer_outlined,
            text: "Ifatwa",
            url: "https://ifatwa.info/",
          ),
          _drawerItem(
            icon: Icons.people_outline,
            text: "Ummah QA",
            url: "https://ummahqa.com/",
          ),
          _drawerItem(
            icon: Icons.account_balance_outlined,
            text: "Ahlia",
            url: "https://ahlia.org/",
          ),
          _drawerItem(
            icon: Icons.apartment_outlined,
            text: "UIS",
            url: "https://uis.edu.bd/",
          ),
          _drawerItem(
            icon: Icons.local_hospital_outlined,
            text: "I Clinic",
            url: "http://iclinicbd.com/",
          ),
          _drawerItem(
            icon: Icons.school,
            text: "UIS BD",
            url: "https://uisbd.org/",
          ),

          const Divider(),

          /// Social Section
          _sectionTitle("IOM Social Pages"),
          _drawerItem(
            icon: Icons.facebook,
            text: "IRC",
            url: "https://www.facebook.com/iomirc",
            isSocial: true,
          ),
          _drawerItem(
            icon: Icons.facebook,
            text: "IMC",
            url: "https://www.facebook.com/imciom",
            isSocial: true,
          ),
          _drawerItem(
            icon: Icons.facebook,
            text: "IBD",
            url: "https://www.facebook.com/iom.ibd",
            isSocial: true,
          ),
          _drawerItem(
            icon: Icons.facebook,
            text: "IUC",
            url: "https://www.facebook.com/iuciom",
            isSocial: true,
          ),
        ],
      ),
    );
  }

  /// Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  /// Drawer Item Widget
  Widget _drawerItem({
    bool isSocial = false,
    required IconData icon,
    required String text,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade700),
      title: Text(text, style: const TextStyle(fontSize: 15)),
      onTap: () {
        Get.back();
        if(isSocial){
          _launchUrl(url);
        }else{
          Get.to(() => WebViewScreen(url: url, title: text));
        }
      },
    );
  }



  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

}