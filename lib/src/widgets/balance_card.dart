import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/theme/light_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wallet_app/src/pages/history.dart';
import 'package:firebase_database/firebase_database.dart';

final _userRef = FirebaseDatabase(
        databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
    .reference()
    .child("data")
    .child("user")
    .child("userid")
    .child("balance");

class BalanceCard extends StatefulWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  String balance = "";
  String id = "";

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  void _fetchBalance() {
    _userRef.once().then((DataSnapshot snapshot) {
      setState(() {
        balance = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .27,
            color: LightColor.navyBlue1,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total Balance,',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: LightColor.lightNavyBlue),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'RM ',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: LightColor.yellow.withAlpha(200)),
                        ),
                        Text(
                          balance,
                          style: GoogleFonts.merriweather(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: LightColor.yellow2),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text(
                    //       'Eq:',
                    //       style: GoogleFonts.muli(
                    //           textStyle: Theme.of(context).textTheme.headline4,
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.w600,
                    //           color: LightColor.lightNavyBlue),
                    //     ),
                    //     Text(
                    //       ' \$10,000',
                    //       style: TextStyle(
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.w500,
                    //           color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 85,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => history(12)),
                              );
                            },
                            color: LightColor.navyBlue1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                side:
                                    BorderSide(color: Colors.white, width: 1)),

                            // decoration: BoxDecoration(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(12)),
                            //     border:
                            //         Border.all(color: Colors.white, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text("Top up",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )))
                  ],
                ),
                Positioned(
                  left: -170,
                  top: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: LightColor.lightBlue2,
                  ),
                ),
                Positioned(
                  left: -160,
                  top: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: LightColor.lightBlue1,
                  ),
                ),
                Positioned(
                  right: -170,
                  bottom: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: LightColor.yellow2,
                  ),
                ),
                Positioned(
                  right: -160,
                  bottom: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: LightColor.yellow,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
