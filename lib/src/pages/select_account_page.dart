// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_wallet_app/src/model/receiver_model.dart';
import 'package:flutter_wallet_app/src/pages/send_money_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _userRef = FirebaseDatabase(
        databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
    .reference()
    .child("data")
    .child("user");
User _user;

class SelectAccountPageRoute extends PageRouteBuilder {
  SelectAccountPageRoute()
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return SelectAccountPage();
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

class SelectAccountPage extends StatefulWidget {
  @override
  SelectAccountPageState createState() => SelectAccountPageState();
}

class SelectAccountPageState extends State<SelectAccountPage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowSearchButton = false;
  int selectedIndex = 0;

  List<ReceiverModel> receiversData = [];

  @override
  void initState() {
    _user = _auth.currentUser;
    _userRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((k, v) {
        if (_user.uid != k) {
          setState(() {
            receivers.add(ReceiverModel(v["uid"], v["displayName"], v["mobile"],
                v["photoURL"], v["balance"], v["email"]));
          });
        }
      });
    });
    super.initState();
  }

  List<ReceiverModel> receivers = [];

  List<ReceiverModel> searchResults = [];

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
            _getSearchSection(),
            _getAccountListSection()
          ],
        ),
      ),
    );
  }

  Widget _getSearchSection() {
    Widget searchBar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration.collapsed(
                hintText: 'Search for Phone number or Username',
              ),
              onChanged: _searchTextChanged,
            ),
          ),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      height: 56.0,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: searchBar,
        ),
      ),
    );
  }

  Widget _getAccountListSection() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Card(
                color: Colors.white,
                child: ListView.builder(
                    itemCount: searchController.text.isEmpty
                        ? receivers.length
                        : searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _getReceiverSection(searchController.text.isEmpty
                          ? receivers[index]
                          : searchResults[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getReceiverSection(ReceiverModel receiver) {
    return GestureDetector(
      onTapUp: (tapDetail) {
        Navigator.push(context, SendMoneyPageRoute(receiver));
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                  backgroundImage: receiver.photoURL.isNotEmpty
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
                      style:
                          TextStyle(fontSize: 12.0, color: Color(0xFF929091)),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void _searchTextChanged(String text) {
    isShowSearchButton = text.isNotEmpty;
    searchResults = receivers.where((i) {
      return i.displayName.toLowerCase().contains(text.toLowerCase()) ||
          i.mobile.toLowerCase().contains(text.toLowerCase());
    }).toList();
    setState(() {});
  }
}
