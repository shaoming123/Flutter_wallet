import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/theme/light_color.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key key}) : super(key: key);
  // BottomNavigationBarItem _icons(IconData icon) {
  //   return BottomNavigationBarItem(
  //       icon: Icon(
  //         icon,
  //       ),
  //       // ignore: deprecated_member_use
  //       title: Text(''));
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return BottomNavigationBar(
  //     showUnselectedLabels: false,
  //     showSelectedLabels: false,
  //     selectedItemColor: LightColor.navyBlue2,
  //     unselectedItemColor: LightColor.grey,
  //     currentIndex: 0,
  //     items: [
  //       _icons(
  //         Icons.home,
  //       ),
  //       _icons(Icons.history),
  //       _icons(Icons.notifications_none),
  //       _icons(Icons.person_outline),
  //     ],

  //    items: const <BottomNavigationBarItem>[
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.call),
  //       label: 'Calls',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.camera),
  //       label: 'Camera',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.chat),
  //       label: 'Chats',
  //     ),
  //   ],
  //   );
  // }

  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
