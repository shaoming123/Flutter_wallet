// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/model/Failure.dart';
import 'package:flutter_wallet_app/src/model/Successful.dart';
import 'package:flutter_wallet_app/src/model/receiver_model.dart';
import 'package:flutter_wallet_app/src/pages/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

User _user;
final _dateTime = DateTime.now().millisecondsSinceEpoch.toString();
final FirebaseAuth _auth = FirebaseAuth.instance;
final _userRef = FirebaseDatabase(
        databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
    .reference()
    .child("data");

class SendMoneyPageRoute extends PageRouteBuilder {
  SendMoneyPageRoute(ReceiverModel receiver)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return SendMoneyPage(
              receiver: receiver,
            );
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: new SlideTransition(
                position: new Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
          },
        );
}

class SendMoneyPage extends StatefulWidget {
  final ReceiverModel receiver;

  SendMoneyPage({this.receiver});

  @override
  SendMoneyPageState createState() => SendMoneyPageState();
}

class SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController _amountController = TextEditingController();

  int selectedCardIndex = 0;
  @override
  void initState() {
    _user = _auth.currentUser;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
                      'Send Money',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 20.0),
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return _getSection(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSection(int index) {
    switch (index) {
      case 0:
        return _getReceiverSection(widget.receiver);

      case 1:
        return _getEnterAmountSection();
      case 2:
        return _getSendSection(widget.receiver);
    }
    return SomethingWentWrong();
  }

  Widget _getReceiverSection(ReceiverModel receiver) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: receiver.photoURL != "assets/face.jpg"
                  ? NetworkImage(receiver.photoURL)
                  : AssetImage('assets/face.jpg')),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                receiver.displayName,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.phone,
                      size: 13.0,
                      color: Color(0xFF929091),
                    ),
                  ),
                  Text(
                    receiver.mobile,
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF929091)),
                  ),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _getEnterAmountSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Enter Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '\RM',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Amount',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSendSection(ReceiverModel receiver) {
    bool _isBalanceEnough;
    String _category = "transfer";
    String transactionid = "";
    final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    transactionid = _user.uid + dateTime;
    return Container(
      margin: EdgeInsets.all(16.0),
      child: GestureDetector(
        onTapUp: (tapDetail) {
          _userRef
              .child("user")
              .child(_user.uid)
              .child("balance")
              .once()
              .then((DataSnapshot snapshot) {
            final String _senderBalance = snapshot.value;
            double _amountTop = double.parse(_amountController.text);
            double _userbalance = double.parse(_senderBalance);
            if (_userbalance >= _amountTop) {
              _isBalanceEnough = true;
            } else {
              _isBalanceEnough = false;
            }
          });
          if (!_isBalanceEnough) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FailurePage()),
            );
          } else {
            _userRef.child("transaction").child(transactionid).set({
              "id": transactionid,
              "amount": _amountController.text,
              "category": _category,
              "timestamp": _dateTime,
              "senderDisplayName": _user.displayName,
              "senderUID": _user.uid,
              "receiverDisplayName": receiver.displayName,
              "receiverUID": receiver.uid
            });
            _userRef
                .child("user")
                .child(_user.uid)
                .child("balance")
                .once()
                .then((DataSnapshot snapshot) {
              final String _senderBalance = snapshot.value;
              double _amountTop = double.parse(_amountController.text);
              double _userbalance = double.parse(_senderBalance);
              String _total = (-_amountTop + _userbalance).toString();
              _userRef
                  .child("user")
                  .child(_user.uid)
                  .update({"balance": _total});
            });

            _userRef
                .child("user")
                .child(receiver.uid)
                .child("balance")
                .once()
                .then((DataSnapshot snapshot) {
              final String _senderBalance = snapshot.value;
              double _amountTop = double.parse(_amountController.text);
              double _userbalance = double.parse(_senderBalance);

              String _total = (_amountTop + _userbalance).toString();
              _userRef
                  .child("user")
                  .child(receiver.uid)
                  .update({"balance": _total});
            });

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuccessfulPage()),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
              color: Color(0xFF65D5E3),
              borderRadius: BorderRadius.all(Radius.circular(11.0))),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
    );
  }
}
