// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_wallet_app/src/model/receiver_model.dart';
import 'package:flutter_wallet_app/src/pages/send_money_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

final _userRef = FirebaseDatabase(
        databaseURL: "https://fireflutter-bcac9-default-rtdb.firebaseio.com/")
    .reference()
    .child("data")
    .child("user");

Future<void> scanQR() async {
  String barcodeScanRes;
  ReceiverModel _receiver;
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    await _userRef.child(barcodeScanRes).once().then((DataSnapshot snapshot) {
      _receiver = ReceiverModel(
        snapshot.value["uid"],
        snapshot.value["displayName"],
        snapshot.value["mobile"],
        snapshot.value["photoURL"],
        snapshot.value["balance"],
        snapshot.value["email"],
      );
    });
    OneContext().push(
        MaterialPageRoute(builder: (_) => SendMoneyPage(receiver: _receiver)));
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
}

class QRscreen extends StatefulWidget {
  @override
  _QRscreenState createState() => _QRscreenState();
}

class _QRscreenState extends State<QRscreen> {
  String _message = "qr code";
  @override
  void initState() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User _user = _auth.currentUser;
    String _json = _user.uid;

    setState(() {
      _user.reload();
      print(_user.displayName);
      _message = _json.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = 280.0;
        if (!snapshot.hasData) {
          return Container(width: size, height: size);
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: _message,
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xff128760),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Color(0xff1a5441),
            ),
            embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(60),
            ),
          ),
        );
      },
    );

    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
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
                        'Receive Money',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700, fontSize: 23.0),
                      ),
                    ],
                  )),
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: qrFutureBuilder,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    Completer completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/logo.PNG');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
