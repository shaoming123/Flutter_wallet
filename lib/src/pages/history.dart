import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/widgets/bottom_navigation_bar.dart';

// ignore: camel_case_types
class history extends StatefulWidget {
  const history(
    int currentIndex, {
    Key? key,
  }) : super(key: key);

  @override
  _historyState createState() => _historyState();
}

// ignore: camel_case_types
class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      appBar: new AppBar(
        title: Text("History"),
      ),
    );
  }
}
