// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase(
        databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
    .reference()
    .child("data");
User _user;

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  int _value = 1;
  var dateResult = '';
  bool firstView = true;

  @override
  void initState() {
    _user = _auth.currentUser;
    databaseReference
        .child("transaction")
        .orderByChild('timestamp')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((k, v) {
        DateTime _unixTimestamp =
            DateTime.fromMillisecondsSinceEpoch(int.parse(v["timestamp"]));
        String _date = DateFormat('dd MMMM yyyy').format(_unixTimestamp);
        double _amount = double.parse((v["amount"]));

        if (_user.uid == v["receiverUID"] || _user.uid == v["senderUID"]) {
          String lowCategory = v["category"].toString().toLowerCase();
          if (lowCategory == "top up") {
            histories.add(HistoryModel(
                'images/ico_pay_phone.png', 'Top up', _amount, _date, true));
          } else if (_user.uid == v["receiverUID"]) {
            histories.add(HistoryModel(
                'images/ico_send_money.png',
                'Received from ' + v['senderDisplayName'],
                _amount,
                _date,
                true));
          } else if (lowCategory == "transfer") {
            histories.add(HistoryModel(
                'images/ico_receive_money.png',
                'Transfer to \n' + v['receiverDisplayName'],
                _amount,
                _date,
                false));
          }
        }
      });
      setState(() {
        histories = histories.reversed.toList();
      });
    });
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  final formattedDate = DateFormat('dd MMMM yyyy');
  List<HistoryModel> histories = [];
  List<HistoryModel> _categoryResults = [];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String date = formattedDate.format(selectedDate);
        _pickedDate(date);
      });
  }

  void _pickedDate(date) {
    _categoryResults = histories
        .where((i) => i.date.toLowerCase().contains(date.toLowerCase()))
        .toList();
    setState(() {
      firstView = false;
    });
  }

  var data = '';

  void _searchCategory(value) {
    if (value == 1) {
      data = 'All';
    } else if (value == 2) {
      data = 'Transfer';
    } else if (value == 3) {
      data = 'Received';
    } else if (value == 4) {
      data = 'Top up';
    }
    setState(() {
      _categoryResults = histories.where((i) {
        return i.historyType.toLowerCase().contains(data.toLowerCase()) ||
            data == 'All';
      }).toList();
      firstView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 50.0, bottom: 25.0),
                  child: Text(
                    'Transactions History',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w900, fontSize: 22.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Container(
                            width: 50,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 5.0),
                                    child: DropdownButton(
                                        hint: Text('Category'),
                                        value: _value,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text(
                                              "All",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text(
                                              "Transfer",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            value: 2,
                                          ),
                                          DropdownMenuItem(
                                              child: Text(
                                                "Received",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              value: 3),
                                          DropdownMenuItem(
                                              child: Text(
                                                "Top up",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              value: 4),
                                          DropdownMenuItem(
                                              child: Text(
                                                "Date",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              value: 5),
                                        ],
                                        onChanged: (int value) {
                                          setState(() {
                                            _value = value;
                                            if (value == 5) {
                                              _selectDate(context);
                                            } else {
                                              _searchCategory(_value);
                                            }
                                          });
                                        })))),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _categoryResults.isEmpty && firstView
                          ? histories.length
                          : _categoryResults.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _historyWidget(_categoryResults.isEmpty
                            ? histories[index]
                            : _categoryResults[index]);
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _historyWidget(HistoryModel history) {
    return SingleChildScrollView(
        child: Container(
      height: 80.0,
      margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Image.asset(
                  history.historyAssetPath,
                  height: 30.0,
                  width: 30.0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          history.historyType,
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        history.isReceiver
                            ? '\ + RM ${history.amount}'
                            : '\ - RM ${history.amount}',
                        style: GoogleFonts.roboto(
                            color:
                                history.isReceiver ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              ' ${history.date}',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
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
