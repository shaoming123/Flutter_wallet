import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/theme/light_color.dart';
import 'package:flutter_wallet_app/main.dart';
import 'package:flutter_wallet_app/src/pages/history.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  Widget build(BuildContext context) {
    int index = 0;
    return Material(
        color: Colors.lightBlue,
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, "/");
                break;
              case 1:
                Navigator.pushNamed(context, "/transfer");
                break;
              case 2:
                Navigator.pushNamed(context, "/history");
                break;
            }
          },

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
          ],

          // currentIndex: _selectedIndex, //New
          // onTap: _onItemTapped,
        ));
  }
}
