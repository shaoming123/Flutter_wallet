import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/pages/history.dart';
import 'package:flutter_wallet_app/src/theme/theme.dart';
// import 'package:flutter_wallet_app/src/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/pages/homePage.dart';
import 'src/pages/money_transfer_page.dart';
import 'src/widgets/customRoute.dart';
import 'src/pages/history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wallet App',
        // home: BottomNavigation(),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/': (_) => HomePage(),
          '/transfer': (_) => MoneyTransferPage(),
          "/request": (_) => MoneyTransferPage()
        },
        // ignore: missing_return
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] == '') {
            return null;
          }
          if (pathElements[0] == 'transfer') {
            return CustomRoute<bool>(
                builder: (BuildContext context) => MoneyTransferPage());
          }
        });
  }
}

// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({Key key}) : super(key: key);

//   @override
//   _BottomNavigationState createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   int _currentIndex = 0;
//   final List<Widget> _children = [HomePage(), MoneyTransferPage()];

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _children[_currentIndex], // new
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: onTabTapped, // new
//         currentIndex: _currentIndex, // new
//         items: [
//           new BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             title: Text('Home'),
//           ),
//           new BottomNavigationBarItem(
//             icon: Icon(Icons.mail),
//             title: Text('Messages'),
//           ),
//           new BottomNavigationBarItem(
//               icon: Icon(Icons.person), title: Text('Profile'))
//         ],
//       ),
//     );
//   }
// }
