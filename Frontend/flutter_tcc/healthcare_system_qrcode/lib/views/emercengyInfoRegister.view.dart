import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'dart:developer';
import 'package:healthcare_system_qrcode/views/home.view.dart';

class EmergencyRegisterRoute extends StatefulWidget {
  const EmergencyRegisterRoute({Key? key}) : super(key: key);


  @override
  _EmergencyRegisterRoute createState() => _EmergencyRegisterRoute();
}

class _EmergencyRegisterRoute extends State<EmergencyRegisterRoute> {
  TextEditingController nameController = TextEditingController(text: globals.nome);
  TextEditingController adressController = TextEditingController(text: globals.adress);
  TextEditingController bloodTypeController = TextEditingController(text: globals.bloodType);
  TextEditingController healthInfoController = TextEditingController(text: globals.healthInfo);
  TextEditingController organDonorController = TextEditingController(text: globals.organDonor);
  TextEditingController emergencyContactController = TextEditingController(text: globals.emergencyContact);

runMyRegister() {
    register(nameController.text, adressController.text,bloodTypeController.text,healthInfoController.text,organDonorController.text,emergencyContactController.text).then((value) {
      if (value == true) {
          showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Tudo Certo"),
              content: const Text("Dados de emergencia cadastrados com sucesso!"),
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
              title: const Text("Erro"),
              content: const Text("Erro ao cadastrar as informações de emergencia, entre em contato com o suprte!"),
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

  _onClickRegister(BuildContext context) {
    if (globals.nome.isNotEmpty || globals.adress.isNotEmpty || globals.bloodType.isNotEmpty || globals.healthInfo.isNotEmpty || globals.emergencyContact.isNotEmpty ) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Dados de emergencia só podem ser cadastrado uma vez!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    }  else if (nameController.text.isEmpty || adressController.text.isEmpty || healthInfoController.text.isEmpty || bloodTypeController.text.isEmpty || emergencyContactController.text.isEmpty ) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Dados de nome, endereço, tipo sanguíneo e contato de emergencia são obrigatórios"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    }  else {
       runMyRegister();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Informações de Emergencia',
                  style: TextStyle(
                      color: Color.fromARGB(255, 4, 59, 82),
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: nameController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                  hintText: 'Entre com o seu nome completo',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
            
                autofocus: false,
                controller: adressController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Endereço',
                  hintText: 'Entre com o seu endereço',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: bloodTypeController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Tipo Sanguíneo',
                  hintText: 'Entre com o seu tipo sanguíneo',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: organDonorController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Doador de orgãos?',
                  hintText: 'Sim ou não',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: emergencyContactController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Contato de emergencia',
                  hintText:  '+55 00 90000-0000',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: healthInfoController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Informações Adicionais',
                  hintText:  'Entre com informações relevantes sobre o seu estado de saúde',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
             Container(
                height: 50,
                width: 500,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ))),
                  child: const Text('Cadastrar'),
                  onPressed: () {
                    _onClickRegister(context);
                  },
                )),
          ],
        ),
        ),
      ),
    );
  }
}