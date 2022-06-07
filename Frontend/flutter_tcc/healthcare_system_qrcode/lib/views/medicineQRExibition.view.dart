import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'dart:developer';
import 'dart:convert';

class medicineQRExibitionRoute extends StatefulWidget {
  const medicineQRExibitionRoute({Key? key}) : super(key: key);


  @override
  _medicineQRExibitionRoute createState() => _medicineQRExibitionRoute();
}

class _medicineQRExibitionRoute extends State<medicineQRExibitionRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Medicamento'),
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
                    image: MemoryImage(base64Decode(globals.QRActualMedicine)),
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