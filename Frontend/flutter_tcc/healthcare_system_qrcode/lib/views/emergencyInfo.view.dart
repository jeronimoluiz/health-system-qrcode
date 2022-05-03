import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'dart:developer';

class EmergencyInfoRoute extends StatefulWidget {
  const EmergencyInfoRoute({Key? key}) : super(key: key);


  @override
  _EmergencyInfoRoute createState() => _EmergencyInfoRoute();
}

class _EmergencyInfoRoute extends State<EmergencyInfoRoute> {
  TextEditingController nameController = TextEditingController(text: globals.nome);
  TextEditingController adressController = TextEditingController(text: globals.adress);
  TextEditingController bloodTypeController = TextEditingController(text: globals.bloodType);
  TextEditingController healthInfoController = TextEditingController(text: globals.healthInfo);
  TextEditingController organDonorController = TextEditingController(text: globals.organDonor);
  TextEditingController emergencyContactController = TextEditingController(text: globals.emergencyContact);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
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
          ],
        ),
      ),
    );
  }
}