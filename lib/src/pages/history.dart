import 'package:flutter/material.dart';

// ignore: camel_case_types
class history extends StatefulWidget {
  const history(int currentIndex, {Key key, this.color}) : super(key: key);

  final Color color;

  @override
  _historyState createState() => _historyState();
}

// ignore: camel_case_types
class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("History"),
      ),
    );
  }
}
