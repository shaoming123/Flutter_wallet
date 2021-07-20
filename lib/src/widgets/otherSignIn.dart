// @dart=2.9

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_wallet_app/src/model/FadeAnimation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class OtherProvidersSignInSection extends StatefulWidget {
  OtherProvidersSignInSection();

  @override
  State<StatefulWidget> createState() => _OtherProvidersSignInSectionState();
}

class _OtherProvidersSignInSectionState
    extends State<OtherProvidersSignInSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FadeAnimation(
              1.4,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                    // icon: Image.asset('assets/googleicon.png')
                  ),
                  //  icon: AnimatedIcons(Icons.android),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      _signInWithGoogle();
                    },
                    color: Colors.blueAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        )
                      ],
                      // child: Text(
                      //   'Sign in with Google',
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18),
                      // ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Sign In ${user.uid} with Google'),
      ));

      databaseReference
          .child("data")
          .child("user")
          .child(user.uid)
          .once()
          .then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value}');
        if (snapshot.value == null) {
          databaseReference
              .child("data")
              .child("user")
              .child(user.uid)
              .set({"uid": user.uid, "balance": "0"});
        }
      });
      Navigator.pushNamed(context, "/");
    } catch (e) {
      print(e);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with Google: $e'),
        ),
      );
    }
  }
}
