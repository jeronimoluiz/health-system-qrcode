import 'dart:developer';
import 'package:flutter/material.dart';
import 'emercengyInfoRegister.view.dart';
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'myQRExibition.view.dart';
import 'QREmergencyExibition.view.dart';
import 'package:healthcare_system_qrcode/views/medicineRegister.view.dart';
import  'package:healthcare_system_qrcode/qrcode.dart' as scanner;
import 'package:healthcare_system_qrcode/views/emergencyInfo.view.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:healthcare_system_qrcode/views/prescriptionRegister.view.dart';
import 'package:healthcare_system_qrcode/views/flow.view.dart';
import 'package:healthcare_system_qrcode/controller/myQR.controller.dart';
import 'package:healthcare_system_qrcode/views/medicineQR.view.dart';
import 'package:healthcare_system_qrcode/controller/prescriptionRegister.controller.dart';
import 'package:healthcare_system_qrcode/views/selectPrescription.view.dart';


class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  get context => context;

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

  _onClickGenarateEmergencyQR(BuildContext context) {
    generate().then((value) {
      if (value == true) {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const emergencyQRExibitionRoute()),
        );
      } else {
       showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Informações de emergencia ainda não foram cadastradas!"),
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

   _onClickGenarateMyQR(BuildContext context) {
    generateMyQR().then((value) {
      if (value == true) {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const myQRExibitionRoute()),
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

  _onClickPrescriptionRegister(BuildContext context) {    
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => prescriptionRegisterRoute()),
    );
  }

  _onClickQRMedicine(BuildContext context) {    
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => medicineQRRoute()),
    );
  }

  _onClickFlow(BuildContext context) {    
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QRCodePage()),
    );
  }
  
  _onClickSelectPrescription(BuildContext context) {    
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => selectPrescriptionRoute()),
    );
  }

    runMyScanner(BuildContext context) {
    scanner.readQRCode().then((value) {
      if (value == '-1') {
        log('error');
      } else {
        _onClickLoadQR(value, context);
      }
    }, onError: (error) {
      return (error);
    });
  }

  _onClickLoadQR(String hsh, BuildContext context) {
    loadQR(hsh).then((value) {
      if (value == true) {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmergencyInfoRoute()),
        );
      } else {
       showDialog(
        context: context ,
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

  _onClickprescriptionScanner(BuildContext context) {
    scanner.readQRCode().then((value) {
      if (value == '-1') {
        log('error');
      } else {
        _validatePrescription(context,value);
      }
    }, onError: (error) {
      return (error);
    });
  }

 _validatePrescription(BuildContext context, String hsh) {
    validatePrescription(hsh).then((value) {
      if (value == true) {
       showDialog(
        context: context ,
        builder: (context) {
          return AlertDialog(
              title: const Text("Tudo certo"),
              content: const Text("Esta é uma prescrição verdadeira!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
      } else {
        showDialog(
          context: context ,
          builder: (context) {
            return AlertDialog(
                title: const Text("Erro"),
                content: const Text("Esta não é uma prescrição válida!"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Container(
                  height: 125.0,
                  width: 145.52,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logopr.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),*/
              SizedBox(height: 30),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Cadastro de Informações de Emergencia'),
                    onPressed: () {
                      _onClickEmergencyInfoRegister(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Exibir QR Code de emergencia'),
                    onPressed: () {
                      _onClickGenarateEmergencyQR(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Cadastrar Medicamento'),
                    onPressed: () {
                      _onClickRegisterMedicine(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Cadastrar Prescrição'),
                    onPressed: () {
                      _onClickPrescriptionRegister(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Meu QRCode'),
                    onPressed: () {
                      _onClickGenarateMyQR(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Minhas Prescrições'),
                    onPressed: () {
                      _onClickSelectPrescription(context);
                    },
                  )
              ),              
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Vizualizar QRCode medicamento'),
                    onPressed: () {
                      _onClickQRMedicine(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Fluxo Procedimento'),
                    onPressed: () {
                      _onClickFlow(context);
                    },
                  )
              ),
              SizedBox(height: 10),
              Container(
                  height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                    child: const Text('Validar Prescrição'),
                    onPressed: () {
                      _onClickprescriptionScanner(context);
                    },
                  )
              ),
              SizedBox(height: 70),
              Container(
                    height: 50,
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 209, 0, 0)),
                      ),
                      child: const Text('Dados Emergenciais'),
                      onPressed: () {
                        runMyScanner(context);
                        //_onClickQrCode(context);

                      },
                    )),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text('',),
              ),
            ],
        ),
        ),
    ),
    );
  }
}
