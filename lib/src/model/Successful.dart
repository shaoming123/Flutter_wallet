import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/pages/homePage.dart';

class SuccessfulPage extends StatelessWidget {
  const SuccessfulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Image(
                      image: AssetImage("images/ico_success.jpg"),
                      width: 100.0,
                      height: 100.0),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Payment Successful!',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(0),
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    color: Colors.white,
                    child: Text(
                      'Back to HomePage',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/");
                    },
                  ),
                ]))));
  }
}
