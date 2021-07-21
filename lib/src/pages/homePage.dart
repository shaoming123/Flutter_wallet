// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/pages/HistoryPage.dart';
import 'package:flutter_wallet_app/src/pages/select_account_page.dart';
import 'package:flutter_wallet_app/src/pages/send_money_page.dart';
import 'package:flutter_wallet_app/src/theme/light_color.dart';
// ignore: unused_import
import 'package:flutter_wallet_app/src/theme/theme.dart';
import 'package:flutter_wallet_app/src/widgets/balance_card.dart';
import 'package:flutter_wallet_app/src/widgets/bottom_navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_wallet_app/src/widgets/title_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import './infoValidate.dart';
import 'HistoryPage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase(
        databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
    .reference();

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  bool _hasInfo = true;
  List<HistoryModel> histories = [];

  @override
  void initState() {
    user = _auth.currentUser;
    databaseReference
        .child("data")
        .child("user")
        .child(user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value["displayName"] == null ||
          snapshot.value["mobile"] == null) {
        setState(() {
          _hasInfo = false;
        });
      }
    });

    databaseReference
        .child("data")
        .child("transaction")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((k, v) {
        DateTime _unixTimestamp =
            DateTime.fromMillisecondsSinceEpoch(int.parse(v["timestamp"]));
        String _date = DateFormat.yMMMMd('en_US').format(_unixTimestamp);
        double _amount = double.parse(v["amount"]);
        if (user.uid == v["receiverUID"] || user.uid == v["senderUID"]) {
          setState(() {
            if (v["category"] == "Top up") {
              histories.add(HistoryModel(
                  'images/ico_pay_phone.png', 'Top up', _amount, _date, true));
            }
            if (v["category"] == "Transfer") {
              histories.add(HistoryModel(
                  'images/ico_receive_money.png',
                  'transfer to ' + v['receiverDisplayName'],
                  _amount,
                  _date,
                  false));
            }
            if (v["category"] == "Request") {
              histories.add(HistoryModel(
                  'images/ico_send_money.png',
                  'Received from ' + v['senderDisplayName'],
                  _amount,
                  _date,
                  true));
            }
          });
        }
      });
    });
    super.initState();
  }

  Widget _appBar() {
    return Row(
      children: <Widget>[
        CircleAvatar(
            backgroundImage: user.photoURL.isNotEmpty
                ? NetworkImage(user.photoURL)
                : AssetImage('assets/face.jpg')),
        SizedBox(width: 15),
        TitleText(text: "Hello,"),
        Text(user.displayName ?? "user",
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
              GoogleSignIn().disconnect();
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
                    MaterialPageRoute(
                        builder: (context) => SelectAccountPage()),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Icon(Icons.transfer_within_a_station),
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
                    MaterialPageRoute(builder: (context) => HistoryPage()),
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

  Widget _transectionList() {
    return Column(
        children: histories
            .map((val) => _transection(val.historyAssetPath, val.historyType,
                val.amount, val.date, val.isReceiver))
            .take(5)
            .toList());
  }

  Widget _transection(String historyAssetPath, String historyType,
      double amount, String date, bool isReceiver) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Image.asset(
          historyAssetPath,
          height: 30.0,
          width: 30.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(),
      title: TitleText(
        text: historyType,
        fontSize: 14,
      ),
      subtitle: Text(date),
      trailing: Container(
          height: 30,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: LightColor.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(amount.toString(),
              style: GoogleFonts.merriweather(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isReceiver ? Colors.green : Colors.red))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !_hasInfo
        ? InfoValidate()
        : Scaffold(
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
                        text: "Latest Transactions",
                      ),
                      _transectionList(),
                    ],
                  )),
            )));
  }
}

class HistoryModel {
  final String historyAssetPath;
  final String historyType;
  final double amount;
  final String date;
  final bool isReceiver;

  HistoryModel(this.historyAssetPath, this.historyType, this.amount, this.date,
      this.isReceiver);
}
