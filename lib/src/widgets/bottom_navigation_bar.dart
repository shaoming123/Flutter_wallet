import 'package:flutter/material.dart';
// import 'package:flutter_wallet_app/src/theme/light_color.dart';

// import 'package:flutter_wallet_app/src/pages/HistoryPage.dart';
// import 'package:flutter_wallet_app/src/pages/ProfilePage.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
          _navigateToScreens(index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: index == 0
                ? Image.asset('images/ico_home_selected.png')
                : Image.asset('images/ico_home.png'),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: index == 1
                ? Image.asset('images/ico_history_selected.png')
                : Image.asset('images/ico_history.png'),
            title: Text(
              'History',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: index == 2
                ? Image.asset('images/ico_profile_selected.png')
                : Image.asset('images/ico_profile.png'),
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreens(index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');

        break;
      case 1:
        Navigator.pushNamed(context, '/history');

        break;
      default:
        Navigator.pushNamed(context, '/ProfilePage');
        break;
    }
  }
}
