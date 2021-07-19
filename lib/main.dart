import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/theme/theme.dart';
// import 'package:flutter_wallet_app/src/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/pages/money_transfer_page.dart';
import 'src/widgets/customRoute.dart';
import 'src/pages/history.dart';
import 'src/pages/error.dart';
import 'src/pages/loading.dart';
import 'src/pages/auth_selector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wallet App',
        // home: BottomNavigation(),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.merriweatherTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/': (_) => AuthTypeSelector(),
          '/transfer': (_) => MoneyTransferPage(),
          "/history": (_) => history(123),
        },
        // ignore: missing_return
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name!.split('/');
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

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Loading();
    }

    return MyApp();
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
