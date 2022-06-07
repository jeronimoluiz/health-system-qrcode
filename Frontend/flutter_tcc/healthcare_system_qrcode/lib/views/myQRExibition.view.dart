import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'dart:developer';
import 'dart:convert';

class myQRExibitionRoute extends StatefulWidget {
  const myQRExibitionRoute({Key? key}) : super(key: key);


  @override
  _myQRExibitionRoute createState() => _myQRExibitionRoute();
}

class _myQRExibitionRoute extends State<myQRExibitionRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu QR Code'),
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
                    image: MemoryImage(base64Decode(globals.myQRb64)),
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
