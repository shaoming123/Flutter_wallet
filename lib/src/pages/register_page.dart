// @dart=2.9

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../widgets/otherSignIn.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            widget.title,
            style: TextStyle(color: Color(0xff001035)),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.network(
                          'https://cdn.iconscout.com/icon/free/png-512/flutter-2038877-1720090.png'),
                    ),
                    Form(
                        key: _formKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailController,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                      labelText: 'Password'),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  alignment: Alignment.center,
                                  child: SignInButtonBuilder(
                                    icon: Icons.person_add,
                                    backgroundColor: Colors.blueGrey,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        await _register();
                                      }
                                    },
                                    text: 'Register',
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(_success == null
                                      ? ''
                                      : (_success
                                          ? 'Successfully registered $_userEmail'
                                          : 'Registration failed')),
                                )
                              ],
                            ),
                          ),
                        )),
                    OtherProvidersSignInSection()
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
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
    } else {
      _success = false;
    }
  }
}
