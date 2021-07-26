// @dart=2.9

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_wallet_app/src/model/FadeAnimation.dart';
import 'package:flutter_wallet_app/src/pages/signin_page.dart';
import 'package:firebase_database/firebase_database.dart';

import '../widgets/otherSignIn.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
final _scaffoldKey = GlobalKey<ScaffoldState>();

class RegisterPage extends StatefulWidget {
  final String title = 'Registration';

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success;
  String _userEmail = '';
  String _passwordError = "";
  String _errorMsg = '';

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[,.!@#\$&*~<>?:%^()]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height * 2,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Sign up",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                                1.2,
                                Text(
                                  "Create an account, It's free",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[700]),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Email',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          obscureText: false,
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400])),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400])),
                                          ),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Password',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400])),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[400]),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.red),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[400],
                                                  width: 2.0),
                                            ),
                                            errorText: _passwordError.isEmpty
                                                ? null
                                                : _passwordError,
                                          ),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            if (value.length < 8) {
                                              return 'Password should be at least 8 characters';
                                            }

                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Confirm Password',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400])),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey[400])),
                                          ),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            if (value !=
                                                _passwordController.text)
                                              return 'The passwords are not matched';
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        FadeAnimation(
                                            1.5,
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 3, left: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.black),
                                                    top: BorderSide(
                                                        color: Colors.black),
                                                    left: BorderSide(
                                                        color: Colors.black),
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                  )),
                                              child: MaterialButton(
                                                minWidth: double.infinity,
                                                height: 60,
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    if (!validateStructure(
                                                        _passwordController
                                                            .text)) {
                                                      setState(() {
                                                        print(
                                                            _passwordController
                                                                .text);
                                                        _passwordError =
                                                            "Password should contains at least one \nupper case, lower case, digit and special \ncharacter ";
                                                      });
                                                      return;
                                                    } else {
                                                      _register();
                                                    }
                                                  }
                                                },
                                                color: Colors.greenAccent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Text(
                                                  "Sign up",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            )),
                                      ])),
                              Container(
                                alignment: Alignment.center,
                                child: Text(_success == null
                                    ? ''
                                    : (_success
                                        ? 'Successfully registered $_userEmail'
                                        : _errorMsg)),
                              ),
                              OtherProvidersSignInSection(),
                              FadeAnimation(
                                  1.6,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Already have an account?"),
                                      RaisedButton(
                                        padding: EdgeInsets.all(0),
                                        elevation: 0,
                                        hoverElevation: 0,
                                        focusElevation: 0,
                                        highlightElevation: 0,
                                        color: Colors.white,
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()),
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                            ],
                          )),
                    ]),
              )),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
        databaseReference
            .child("data")
            .child("user")
            .child(user.uid)
            .once()
            .then((DataSnapshot snapshot) {
          if (snapshot.value == null) {
            databaseReference.child("data").child("user").child(user.uid).set({
              "uid": user.uid,
              "email": user.email,
              "balance": "0",
              "mobile": "",
              "displayName": "",
              "photoURL": "assets/face.jpg"
            });
          }
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        _success = false;
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: Text(await e.message),
        ),
      );
    }
  }
}
