// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/model/Failure.dart';
import 'package:flutter_wallet_app/src/model/Successful.dart';
import 'package:flutter_wallet_app/src/pages/homePage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Topup extends StatefulWidget {
  const Topup({Key key}) : super(key: key);

  @override
  _TopupState createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  TextEditingController _controller = TextEditingController();
  Razorpay _razorpay;
  String amount = "";
  String id = "";
  String category = "";
  String senderDisplayName = "";
  String senderUID = "";
  String receiverDisplayName = "";
  String receiverUID = "";
  String timestamp = "";
  String transactionid = "";
  String balance;
  User _user;

  final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
  //  Timestamp myTimeStamp = Timestamp.fromDate(currenttimestamp);
  // final String currenttimestamp = (new DateTime.now().millisecondsSinceEpoch);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userRef = FirebaseDatabase(
          databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
      .reference()
      .child("data");

  @override
  void initState() {
    _razorpay = Razorpay();
    _user = _auth.currentUser;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _TopupHis(amount) {
    transactionid = _user.uid + dateTime;
    print(dateTime);
    _userRef.child("transaction").child(transactionid).set({
      "id": _user.uid + dateTime,
      "amount": amount,
      "category": "Top up",
      "timestamp": dateTime,
      "senderDisplayName": senderDisplayName,
      "senderUID": senderUID,
      "receiverDisplayName": receiverDisplayName,
      "receiverUID": _user.uid
    });
  }

  void _fetchBalance(amount) {
    _userRef.child("user").child(_user.uid).child("balance")
      ..once().then((DataSnapshot snapshot) {
        setState(() {
          balance = snapshot.value;
        });
        double amountTop = double.parse(amount);
        double userbalance = double.parse(balance);

        var Total = (amountTop + userbalance).toString();
        _userRef.child("user").child(_user.uid).update({"balance": Total});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Text(
                      'Top up wallet',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20.0),
                    ),
                  ],
                )),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11.0))),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0),
                          child: Text(
                            'Enter Amount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 20),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '\RM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: TextField(
                                    controller: _controller,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: 'Amount',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        RaisedButton(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          elevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          // margin: EdgeInsets.all(16.0),
                          onPressed: () {
                            openCheckout();
                          },

                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Color(0xFF65D5E3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11.0))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text(
                              'SEND',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // _getReceiverSection(this.widget.receiver),
            // _getEnterAmountSection()
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    // print(topup);
    var options = {
      'key': 'rzp_test_HrKYY6mdiMRJLt',
      'amount':
          (double.parse(_controller.text) * 100.roundToDouble()).toString(),
      'name': 'Ming.',
      'description': 'Top up wallet',
      'prefill': {'contact': '0167108890', 'email': 'asda@sdsd.com'},
      'external': {
        'wallets': [''],
        'currency': 'MYR'
      }
    };

    try {
      _razorpay.open(options);
      // totala(total);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  // void totala(total) {
  //   double test = (double.parse(_controller.text));
  //   double word = double.parse(total);
  //   total = word + test;
  //   print(total);
  // }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String topupAmount =
        (double.parse(_controller.text).roundToDouble()).toString();
    // print(topupAmount);
    _TopupHis(topupAmount);
    _fetchBalance(topupAmount);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SuccessfulPage()),
      (Route<dynamic> route) => false,
    );

    // ignore: deprecated_member_use
    // Scaffold.of(context)
    //     // ignore: deprecated_member_use
    //     .showSnackBar(SnackBar(content: Text("Successful Top up ")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // ignore: deprecated_member_use
    // Scaffold.of(context).showSnackBar(SnackBar(
    //     content: Text(
    //         "ERROR: " + response.code.toString() + " - " + response.message)));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FailurePage()),
      (Route<dynamic> route) => false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("EXTERNAL_WALLET: " + response.walletName)));
  }

  // void totala(total) {

  // }
}
