import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/widgets/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  int _value = 1;
  var dateResult = '';

  DateTime selectedDate = DateTime.now();
  final formattedDate = DateFormat('dd MMMM yyyy');
  List<HistoryModel> histories = [
    HistoryModel('images/ico_send_money.png', 'Top up', 99.0, '08 July 2021',
        'images/ico_logo_red.png'),
    HistoryModel('images/ico_pay_elect.png', 'Transfer to boon', 80.0,
        '15 July 2021', 'images/ico_logo_red.png'),
    HistoryModel('images/ico_pay_phone.png', 'Transfer to kelvin ', 30.0,
        '08 July 2021', 'images/ico_logo_red.png'),
    HistoryModel('images/ico_receive_money.png', 'Received from ting', 30.0,
        '18 July 2021', 'images/ico_logo_blue.png'),
    HistoryModel('images/ico_receive_money.png', 'Received from tang', 30.0,
        '28 July 2021', 'images/ico_logo_blue.png'),
    HistoryModel('images/ico_receive_money.png', 'Received from ting', 30.0,
        '18 July 2021', 'images/ico_logo_blue.png'),
  ];
  // List<HistoryModel> DateResults = [];
  List<HistoryModel> CategoryResults = [];

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

    // print(formattedDate.format(selectedDate));
    // print(DateResults);
  }

  void _pickedDate(date) {
    // isShowSearchButton = text.isNotEmpty;
    CategoryResults = histories
        .where((i) => i.date.toLowerCase().contains(date.toLowerCase()))
        .toList();
  }

  var data = '';

  void _searchCategory(value) {
    if (value == 1) {
      data = '';
    } else if (value == 2) {
      data = 'Transfer';
    } else if (value == 3) {
      data = 'Received';
    } else if (value == 4) {
      data = 'top up';
    }
    print(data);
    print(dateResult);
    CategoryResults = histories.where((i) {
      return i.historyType.toLowerCase().contains(data.toLowerCase());
      // i.date.toLowerCase().contains(dateResult.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(),
      backgroundColor: Color(0xFFF4F4F4),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 50.0, bottom: 25.0),
              child: Text(
                'Transactions History',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10.0),
//              height: 42.0,
                child: Row(children: <Widget>[
                  // Expanded(
                  //   child: Row(
                  //     children: <Widget>[
                  //       // ignore: deprecated_member_use
                  //       RaisedButton(
                  //         padding: EdgeInsets.symmetric(
                  //             horizontal: 50.0, vertical: 16.0),

                  //         color: Colors.white,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //         onPressed: () {
                  //           _selectDate(context);
                  //         },
                  //         child: Row(children: <Widget>[
                  //           Text(
                  //             "Date",
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w700, fontSize: 14.0),
                  //           ),
                  //           Icon(Icons.keyboard_arrow_down),
                  //         ]),
                  //         // Icon(Icons.keyboard_arrow_down)
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                        width: 55,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 1), // changes position of shadow
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
                                        child: Text("All"),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Transfer"),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                          child: Text("Request"), value: 3),
                                      DropdownMenuItem(
                                          child: Text("Top up"), value: 4),
                                      DropdownMenuItem(
                                          child: Text("Date"), value: 5),
                                    ],
                                    onChanged: (value) {
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
                  itemCount: CategoryResults.isEmpty
                      ? histories.length
                      : CategoryResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _historyWidget(CategoryResults.isEmpty
                        ? histories[index]
                        : CategoryResults[index]);
                  }),
            ),
          ],
        ),
      ),
    );
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
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
                        '\RM ${history.amount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              ' ${history.date}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 13),
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
  final String cardLogoPath;

  HistoryModel(this.historyAssetPath, this.historyType, this.amount, this.date,
      this.cardLogoPath);
}
