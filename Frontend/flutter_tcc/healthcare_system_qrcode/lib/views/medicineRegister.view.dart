import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/controller/medicineRegister.controller.dart';
import 'package:healthcare_system_qrcode/main.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'dart:developer';

class MedicineRegisterRoute extends StatefulWidget {
  const MedicineRegisterRoute({Key? key}) : super(key: key);

  @override
  _MedicineRegisterRoute createState() => _MedicineRegisterRoute();
}

class _MedicineRegisterRoute extends State<MedicineRegisterRoute> {
  TextEditingController medicineID = TextEditingController();
  TextEditingController medicineName = TextEditingController();
  TextEditingController manufacturer = TextEditingController();
  TextEditingController inventory = TextEditingController();

  String expiration = "";
  late int inventoryValue;

   registerAccepted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Tudo certo!"),
            content: const Text("Medicamento cadastrado com sucesso!"),
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

   registerDenied() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Não foi possível cadastrar o medicamento! Entre em contato com o suporte"),
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

  runMyRegister() {
    register(medicineID.text, medicineName.text,manufacturer.text,expiration,inventory.text).then((value) {
      if (value == true) {
        registerAccepted();
      } else {
        registerDenied();
      }
    }, onError: (error) {
      return (error);
    });
  }

  _onClickRegister(BuildContext context) { 
    if (medicineID.text.isEmpty || medicineName.text.isEmpty || manufacturer.text.isEmpty || inventory.text.isEmpty || expiration.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Todos os campos devem ser preenchidos!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    }else {
        try{
          inventoryValue = int.parse(inventory.text);
        } on Exception catch (_) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text("Erro"),
                  content: const Text("Inventório deve ser um valor inteiro"),
                  actions: <Widget>[
                    TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
            },
          );
          return;
        } 
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
                    'Medicamento',
                    style: TextStyle(
                        color: Color.fromARGB(255, 4, 59, 82),
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autofocus: false,
                  controller: medicineID,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 159, 218, 231),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'ID',
                    hintText: 'Entre com o ID do medicamento',
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
                  controller: medicineName,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 159, 218, 231),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    hintText: 'Entre com o nome do medicamento',
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
                  controller: manufacturer,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 159, 218, 231),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Fabricante',
                    hintText: 'Entre com o fabricante do medicamento',
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
                  controller: inventory,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 159, 218, 231),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Inventório',
                    hintText: 'Entre com o inventório do medicamento',
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
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                child: DateTimePicker(
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data de Validade',
                    onChanged: (val) => expiration = val,
                    validator: (val) {
                      expiration = val!;
                      return null;
                    },
                    onSaved: (val) => expiration = val!,
                  )
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  '',
                ),
              ),
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