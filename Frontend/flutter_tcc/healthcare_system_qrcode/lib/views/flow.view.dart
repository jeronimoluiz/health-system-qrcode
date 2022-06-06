import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:healthcare_system_qrcode/views/home.view.dart';
import  'package:healthcare_system_qrcode/qrcode.dart' as scanner;
import 'dart:developer';
import 'package:healthcare_system_qrcode/controller/flow.controller.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;

class QRCodePage extends StatefulWidget {
  QRCodePage({Key? key}) : super(key: key);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String ticket = '';
  String first = "false"; 
  List<String> tickets = [];

    _flowValidation(BuildContext context){
      validate(tickets.elementAt(0), tickets.elementAt(1), tickets.elementAt(2)).then((value){
        if (value == true) {
        _flowRegister(context);
      } else {
        showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("ERRO"),
                    content: Text("Erro na leitura dos códigos, tente novamente!"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeRoute()),
                            );
                          })
                    ]);
              },
            );
      }
    }, onError: (error) {
      return (error);
   } );
    }

    _flowRegister(BuildContext context){
      register(tickets.elementAt(0), tickets.elementAt(1), tickets.elementAt(2)).then((value){
        if (value == true) {
        showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Prescrição realizada com sucesso!"),
                    content: Text("A realização do uso do medicamento: " + "Cefaliv" + " foi realizado no paciente " + "Lucas Bittencurt" + " pelo agente de saúde " + "João da Silva"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeRoute()),
                            );
                          })
                    ]);
              },
            );
      } else {
        showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("ERRO"),
                    content: Text("Erro no registro da prescrição, tente novamente!"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeRoute()),
                            );
                          })
                    ]);
              },
            );
      }
      });
    }

    runMyScanner(BuildContext context) {
    if (tickets.length == 0){
      showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Leitura QR"),
                    content: Text("Faça a leitura do código do paciente!"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            readQR(context);
                          })
                    ]);
              },
            );
    } else if(tickets.length == 1){
        showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Leitura QR"),
                    content: Text("Faça a leitura do código do agente de saúde!"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            readQR(context);
                          })
                    ]);
              },
            );
    }else if(tickets.length == 2){
        showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Leitura QR"),
                    content: Text("Faça a leitura do código do medicamento prescrito!"),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            readQR(context);
                          })
                    ]);
              },
            );
    }
}

    readQR(BuildContext context){
      scanner.readQRCode().then((value) {
        if (value == '-1') {
          log('error');
        } else {
          tickets.add(value.toString());
          if(tickets.length >= 3){
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text("Leitura Feita"),
                      content: Text("Foram feitas as leituras dos 3 QR Codes!"),
                      actions: <Widget>[
                        TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              _flowValidation(context);
                            })
                      ]);
                },
              );
          }else{
            runMyScanner(context);          
          }
        }
      }, onError: (error) {
        return (error);
      });
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Validação Fluxo Prescrição'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
              ),
            ElevatedButton.icon(
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 4, 148, 148))
                ),
              onPressed: () async {
                        if (first == "true") {
                              runMyScanner(context);
                        } else{
                          first = "true";
                        }
              },
              icon: Icon(Icons.qr_code),
              label: Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}