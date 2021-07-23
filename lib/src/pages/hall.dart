import 'package:flutter/material.dart';

import 'package:flutter_wallet_app/src/pages/HistoryPage.dart';
import 'package:flutter_wallet_app/src/pages/ProfilePage.dart';
import 'package:flutter_wallet_app/src/pages/homePage.dart';
import 'package:google_fonts/google_fonts.dart';

class Hall extends StatefulWidget {
  const Hall({Key? key}) : super(key: key);

  @override
  State<Hall> createState() => _HallState();
}

class _HallState extends State<Hall> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = [
    HomePage(),
    HistoryPage(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            this._selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Image.asset('images/ico_home_selected.png')
                : Image.asset('images/ico_home.png'),
            title: Text(
              'Home',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset('images/ico_history_selected.png')
                : Image.asset('images/ico_history.png'),
            title: Text(
              'History',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Image.asset('images/ico_profile_selected.png')
                : Image.asset('images/ico_profile.png'),
            title: Text(
              'Profile',
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
