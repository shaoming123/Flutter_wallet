import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  final String message;

  const SomethingWentWrong({Key? key, this.message = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        message.isEmpty ? 'SomethingWentWrong' : message,
        style: TextStyle(color: Color(0xFFF4F4F4)),
        textDirection: TextDirection.ltr,
      ),
    ));
  }
}
