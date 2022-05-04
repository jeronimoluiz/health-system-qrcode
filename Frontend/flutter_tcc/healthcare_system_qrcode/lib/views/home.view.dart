import 'dart:developer';
import 'package:flutter/material.dart';
import 'emercengyInfoRegister.view.dart';
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'qrExibition.view.dart';
import 'package:healthcare_system_qrcode/views/medicineRegister.view.dart';

class HomeRoute extends StatelessWidget {
const HomeRoute({Key? key}) : super(key: key);

  _onClickEmergencyInfoRegister(BuildContext context) {
    load().then((value) {
      if (value == true) {
        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmergencyRegisterRoute()),
    );
      } else {
         showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Houve algum erro, contacte o suporte!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
      }
    }, onError: (error) {
      return (error);
    });    
  }

  _onClickGenarateQR(BuildContext context) {
    generate().then((value) {
      if (value == true) {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const qrExibitionRoute()),
        );
      } else {
       showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Houve algum erro, contacte o suporte!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
      }
    }, onError: (error) {
      return (error);
    });    
  }

  _onClickRegisterMedicine(BuildContext context) {    
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MedicineRegisterRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: ElevatedButton(
                  child: const Text('Cadastro de Informações de Emergencia'),
                  onPressed: () {
                    _onClickEmergencyInfoRegister(context);
                  },
                )
            ),
            SizedBox(height: 20),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: ElevatedButton(
                  child: const Text('Exibir QR Code de emergencia'),
                  onPressed: () {
                    _onClickGenarateQR(context);
                  },
                )
            ),
             SizedBox(height: 20),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: ElevatedButton(
                  child: const Text('Cadastrar Medicamento'),
                  onPressed: () {
                    _onClickRegisterMedicine(context);
                  },
                )
            ),
             TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('',),
            ),
          ],
      ),
    ),
    );
  }
}
