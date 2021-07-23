// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User _user = _auth.currentUser;

Future<void> scanQR() async {
  String barcodeScanRes;
  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    //after scanned, create transaction id here
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }
}

class QRscreen extends StatefulWidget {
  @override
  _QRscreenState createState() => _QRscreenState();
}

class _QRscreenState extends State<QRscreen> {
  final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
  String _message = "qr code";
  @override
  void initState() {
    String _transactionid = _user.uid + dateTime;
    Map<String, String> _json = {
      "id": _transactionid,
      "amount": "",
      "category": "Transfer",
      "timestamp": dateTime,
      "senderDisplayName": "",
      "senderUID": "",
      "receiverDisplayName": _user.displayName,
      "receiverUID": _user.uid
    };
    setState(() {
      _message = jsonEncode(_json);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final qrFutureBuilder = FutureBuilder<ui.Image>(
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
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20.0),
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
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/face.jpg');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
