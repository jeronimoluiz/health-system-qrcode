import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'dart:developer';
import 'dart:convert';

class prescriptionViewRoute extends StatefulWidget {
  const prescriptionViewRoute({Key? key}) : super(key: key);


  @override
  _prescriptionViewRoute createState() => _prescriptionViewRoute();
}

class _prescriptionViewRoute extends State<prescriptionViewRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha prescrição'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Container(
                height: 575.0,
                //width: 400.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(globals.actualPrescription)),
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