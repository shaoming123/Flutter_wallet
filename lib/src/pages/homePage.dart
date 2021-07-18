import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/pages/history.dart';
import 'package:flutter_wallet_app/src/theme/light_color.dart';
// ignore: unused_import
import 'package:flutter_wallet_app/src/theme/theme.dart';
import 'package:flutter_wallet_app/src/widgets/balance_card.dart';
import 'package:flutter_wallet_app/main.dart';
import 'package:flutter_wallet_app/src/widgets/bottom_navigation_bar.dart';
import 'history.dart';
import 'package:flutter_wallet_app/src/widgets/title_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _appBar() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(
              "https://jshopping.in/images/detailed/591/ibboll-Fashion-Mens-Optical-Glasses-Frames-Classic-Square-Wrap-Frame-Luxury-Brand-Men-Clear-Eyeglasses-Frame.jpg"),
        ),
        SizedBox(width: 15),
        TitleText(text: "Hello,"),
        Text(' Janth,',
            style: GoogleFonts.merriweather(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: LightColor.navyBlue2)),
        Expanded(
          child: SizedBox(),
        ),
        IconButton(
            icon: Icon(Icons.logout),
            color: Theme.of(context).iconTheme.color,
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, '/');
            })
      ],
    );
  }

  Widget _operationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Column(
        //   children: <Widget>[
        //     // onTap: () {
        //     //   Navigator.pushNamed(context, '/transfer');
        //     // },
        //     // onTap: () {
        //     //   Navigator.pushNamed(context, '/request');
        //     // },
        //     Container(
        //       height: 80,
        //       width: 80,
        //       margin: EdgeInsets.symmetric(vertical: 10),
        //       decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.all(Radius.circular(20)),
        //           boxShadow: <BoxShadow>[
        //             BoxShadow(
        //                 color: Color(0xfff3f3f3),
        //                 offset: Offset(5, 5),
        //                 blurRadius: 10)
        //           ]),
        //       child: Icon(Icons.transfer_within_a_station),
        //     ),
        //     Text("Transfer",
        //         style: GoogleFonts.muli(
        //             textStyle: Theme.of(context).textTheme.headline4,
        //             fontSize: 15,
        //             fontWeight: FontWeight.w600,
        //             color: Color(0xff76797e))),
        //     Container(
        //       height: 80,
        //       width: 80,
        //       margin: EdgeInsets.symmetric(vertical: 10),
        //       decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.all(Radius.circular(20)),
        //           boxShadow: <BoxShadow>[
        //             BoxShadow(
        //                 color: Color(0xfff3f3f3),
        //                 offset: Offset(5, 5),
        //                 blurRadius: 10)
        //           ]),
        //       child: Icon(Icons.call_received),
        //     ),
        //     Text("Request",
        //         style: GoogleFonts.muli(
        //             textStyle: Theme.of(context).textTheme.headline4,
        //             fontSize: 15,
        //             fontWeight: FontWeight.w600,
        //             color: Color(0xff76797e))),
        //   ],
        // )

        Expanded(
          //   ignore: deprecated_member_use
          child: Column(children: [
            ButtonTheme(
              height: 90,
              minWidth: 90,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => history(12)),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                // child: Container(
                //   color: Colors.white,
                //   decoration: BoxDecoration(
                //       boxShadow: <BoxShadow>[
                //         BoxShadow(color: Colors.white, blurRadius: 10)
                //       ]),
                //   child: Icon(Icons.transfer_within_a_station),
                // ),
                child: Icon(Icons.transfer_within_a_station),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(20)),
                //   // boxShadow: <BoxShadow>[
                //   //   BoxShadow(
                //   //       color: Color(0xfff3f3f3),
                //   //       offset: Offset(5, 5),
                //   //       blurRadius: 10)
                //   // ]
                // ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text("Transfer",
                    style: GoogleFonts.merriweather(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff76797e))))
          ]),
        ),

        Expanded(
          //   ignore: deprecated_member_use
          child: Column(children: [
            ButtonTheme(
              height: 90,
              minWidth: 90,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => history(12)),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Icon(Icons.call_received),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text("Request",
                    style: GoogleFonts.merriweather(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff76797e))))
          ]),
        ),
      ],
    );
  }

  // Widget _icon(IconData icon, String text) {
  //   return Column(
  //     children: <Widget>[
  //       // onTap: () {
  //       //   Navigator.pushNamed(context, '/transfer');
  //       // },
  //       // onTap: () {
  //       //   Navigator.pushNamed(context, '/request');
  //       // },
  //       Container(
  //         height: 80,
  //         width: 80,
  //         margin: EdgeInsets.symmetric(vertical: 10),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(20)),
  //             boxShadow: <BoxShadow>[
  //               BoxShadow(
  //                   color: Color(0xfff3f3f3),
  //                   offset: Offset(5, 5),
  //                   blurRadius: 10)
  //             ]),
  //         child: Icon(Icons.transfer_within_a_station),
  //       ),
  //       Text("Transfer",
  //           style: GoogleFonts.muli(
  //               textStyle: Theme.of(context).textTheme.headline4,
  //               fontSize: 15,
  //               fontWeight: FontWeight.w600,
  //               color: Color(0xff76797e))),
  //       Container(
  //         height: 80,
  //         width: 80,
  //         margin: EdgeInsets.symmetric(vertical: 10),
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(20)),
  //             boxShadow: <BoxShadow>[
  //               BoxShadow(
  //                   color: Color(0xfff3f3f3),
  //                   offset: Offset(5, 5),
  //                   blurRadius: 10)
  //             ]),
  //         child: Icon(Icons.call_received),
  //       ),
  //       Text("Request",
  //           style: GoogleFonts.muli(
  //               textStyle: Theme.of(context).textTheme.headline4,
  //               fontSize: 15,
  //               fontWeight: FontWeight.w600,
  //               color: Color(0xff76797e))),
  //     ],
  //   );
  // }

  Widget _transectionList() {
    return Column(
      children: <Widget>[
        _transection("Flight Ticket", "23 Feb 2020"),
        _transection("Electricity Bill", "25 Feb 2020"),
        _transection("Flight Ticket", "03 Mar 2020"),
      ],
    );
  }

  Widget _transection(String text, String time) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: LightColor.navyBlue1,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(Icons.hd, color: Colors.white),
      ),
      contentPadding: EdgeInsets.symmetric(),
      title: TitleText(
        text: text,
        fontSize: 14,
      ),
      subtitle: Text(time),
      trailing: Container(
          height: 30,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: LightColor.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text('-20 MLR',
              style: GoogleFonts.merriweather(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: LightColor.navyBlue2))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigation(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 35),
                  _appBar(),
                  SizedBox(
                    height: 40,
                  ),
                  TitleText(text: "My wallet"),
                  SizedBox(
                    height: 20,
                  ),
                  BalanceCard(),
                  SizedBox(
                    height: 50,
                  ),
                  TitleText(
                    text: "Operations",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _operationsWidget(),
                  SizedBox(
                    height: 40,
                  ),
                  TitleText(
                    text: "Transactions",
                  ),
                  _transectionList(),
                ],
              )),
        )));
  }
}
