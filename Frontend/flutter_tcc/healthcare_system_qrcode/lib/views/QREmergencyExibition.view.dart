import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'dart:developer';
import 'dart:convert';

class emergencyQRExibitionRoute extends StatefulWidget {
  const emergencyQRExibitionRoute({Key? key}) : super(key: key);


  @override
  _emergencyQRExibitionRoute createState() => _emergencyQRExibitionRoute();
}

class _emergencyQRExibitionRoute extends State<emergencyQRExibitionRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code de Emergencia'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Container(
                height: 400.0,
                width: 400.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(globals.QREmergencyb64)),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}