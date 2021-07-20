import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        'SomethingWentWrong',
        style: TextStyle(color: Color(0xFFF4F4F4)),
        textDirection: TextDirection.ltr,
      ),
    ));
  }
}
