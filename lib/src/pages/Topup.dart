// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/model/Failure.dart';
import 'package:flutter_wallet_app/src/model/Successful.dart';
import 'package:flutter_wallet_app/src/pages/infoValidate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
  String _email = "";
  String _mobile = "";
  String _name = "";
  String balance = "";
  User _user;

  final dateTime = DateTime.now().millisecondsSinceEpoch.toString();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userRef = FirebaseDatabase(
          databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
      .reference()
      .child("data");

  @override
  void initState() {
    _razorpay = Razorpay();
    _user = _auth.currentUser;

    _userRef
        .child("user")
        .child(_user.uid)
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        _mobile = snapshot.value["mobile"];
        _email = snapshot.value["email"];
        _name = snapshot.value["displayName"];
      });
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _topupHis() {
    transactionid = _user.uid + dateTime;
    String top_amount = _controller.text.toString();

    _userRef.child("transaction").child(transactionid).set({
      "id": _user.uid + dateTime,
      "amount": top_amount,
      "category": "Top up",
      "timestamp": dateTime,
      "senderDisplayName": senderDisplayName,
      "senderUID": senderUID,
      "receiverDisplayName": receiverDisplayName,
      "receiverUID": _user.uid
    });

    _userRef
        .child("user")
        .child(_user.uid)
        .child("balance")
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        balance = snapshot.value;
      });
      double _amountTop = double.parse(top_amount);
      double _userbalance = double.parse(balance);

      String _total = (_amountTop + _userbalance).toString();
      print(_amountTop);
      _userRef.child("user").child(_user.uid).update({"balance": _total});
    }).catchError((error) {
      print("Something went wrong: ${error.message}");
    });
  }

  // void _fetchBalance() {
  //   _userRef.child("user").child(_user.uid).child("balance")
  //     ..once().then((DataSnapshot snapshot) {
  //       setState(() {
  //         balance = snapshot.value;
  //       });
  //       double _amountTop = double.parse(_controller.text);
  //       double _userbalance = double.parse(balance);

  //       String _total = (_amountTop + _userbalance).toString();
  //       print(_amountTop);
  //       _userRef.child("user").child(_user.uid).update({"balance": _total});
  //     });
  // }

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
                    const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Text(
                      'Top up wallet',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700, fontSize: 25.0),
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
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 16.0, bottom: 20),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '\RM',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35.0),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: TextField(
                                    controller: _controller,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.roboto(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: 'Amount',
                                        labelStyle: GoogleFonts.roboto(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 25.0)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RaisedButton(
                                child: Text(
                                  'RM 100',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // shouldDisplay = !shouldDisplay;
                                    _controller.text = "100";
                                  });
                                },
                                color: Color(0xFFF4F4F4),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              RaisedButton(
                                child: Text(
                                  'RM 500',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // shouldDisplay = !shouldDisplay;
                                    _controller.text = "500";
                                  });
                                },
                                color: Color(0xFFF4F4F4),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              RaisedButton(
                                child: Text(
                                  'RM 1000',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller.text = "1000";
                                  });
                                },
                                color: Color(0xFFF4F4F4),
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
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
                              'Top up',
                              style: GoogleFonts.roboto(
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
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    try {
      var options = {
        'key': 'rzp_test_HrKYY6mdiMRJLt',
        'amount':
            (double.parse(_controller.text) * 100.roundToDouble()).toString(),
        'name': _name,
        'description': 'Top up wallet',
        'prefill': {'contact': "0" + _mobile, 'email': _email},
        'external': {
          'wallets': [''],
        },
        'currency': 'MYR'
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // String topupAmount =
    //     (double.parse(_controller.text).roundToDouble()).toString();
    _topupHis();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SuccessfulPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
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
}
