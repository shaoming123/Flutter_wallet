// @dart=2.9
// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './register_page.dart';
import './signin_page.dart';
import './homePage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthTypeSelector extends StatefulWidget {
  @override
  _AuthTypeSelectorState createState() => _AuthTypeSelectorState();
}

class _AuthTypeSelectorState extends State<AuthTypeSelector> {
  bool isLoggedIn;
  User user;

  @override
  void initState() {
    isLoggedIn = false;
    _auth.userChanges().listen((event) => setState(() => user = event));
    user = _auth.currentUser;
    if (user != null) {
      isLoggedIn = true;
    }

    super.initState();
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? HomePage()
        : Scaffold(
            backgroundColor: Color(0xffffffff),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: FractionalOffset.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 6),
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.black, Colors.blueAccent],
                                    ).createShader(
                                        Rect.fromLTRB(0, 0, 900, 900));
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "Welcome to our Fluuter Dev",
                                    style: TextStyle(
                                        color: Color(0xff161830),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30.0),
                            child: ButtonTheme(
                              minWidth: 400.0,
                              height: 60,
                              child: Container(
                                child: RaisedButton(
                                  onPressed: () =>
                                      _pushPage(context, SignInPage()),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  textColor: Colors.white,
                                  disabledTextColor: Colors.white,
                                  disabledColor: Colors.blueAccent,
                                  color: Colors.blueAccent,
                                  child: new Text("Log In"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 80.0),
                            child: ButtonTheme(
                              minWidth: 400.0,
                              height: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                child: RaisedButton(
                                  onPressed: () =>
                                      _pushPage(context, RegisterPage()),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side:
                                          BorderSide(color: Color(0xff789ff5))),
                                  padding: const EdgeInsets.all(8.0),
                                  textColor: Colors.blueAccent,
                                  disabledColor: Colors.white,
                                  disabledTextColor: Color(0xff161830),
                                  color: Colors.white,
                                  child: new Text("SignUp"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
