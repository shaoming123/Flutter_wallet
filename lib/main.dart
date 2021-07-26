import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/pages/HistoryPage.dart';
import 'package:flutter_wallet_app/src/pages/homePage.dart';
import 'package:flutter_wallet_app/src/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:one_context/one_context.dart';
import 'package:flutter/services.dart';

import 'src/widgets/customRoute.dart';
import 'src/pages/HistoryPage.dart';
import 'src/pages/ProfilePage.dart';
import 'src/pages/error.dart';
import 'src/pages/loading.dart';
import 'src/pages/auth_selector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(App());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wallet App',
        navigatorKey: OneContext().navigator.key,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.merriweatherTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/': (_) => AuthTypeSelector(),
          '/history': (_) => HistoryPage(),
          '/homepage': (_) => HomePage(),
          "/ProfilePage": (_) => ProfilePage(),
        },
        // ignore: missing_return
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name!.split('/');
          if (pathElements[0] == '') {
            return null;
          }
          if (pathElements[0] == 'history') {
            return CustomRoute<bool>(
                builder: (BuildContext context) => HistoryPage());
          }
          if (pathElements[0] == 'ProfilePage') {
            return CustomRoute<bool>(
                builder: (BuildContext context) => ProfilePage());
          }
        });
  }
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
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
    if (_error) {
      return SomethingWentWrong();
    }

    if (!_initialized) {
      return Loading();
    }

    return MyApp();
  }
}
