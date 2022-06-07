import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthcare_system_qrcode/controller/prescriptionRegister.controller.dart';
import 'package:healthcare_system_qrcode/views/home.view.dart';

class prescriptionRegisterRoute extends StatefulWidget {
  const prescriptionRegisterRoute({Key? key}) : super(key: key);

  @override
  _prescriptionRegisterRoute createState() => _prescriptionRegisterRoute();
}

class _prescriptionRegisterRoute extends State<prescriptionRegisterRoute> {
  TextEditingController IDController = TextEditingController();
  TextEditingController apTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var dataList = [];
  List<Map> _myJson = [{"medicineID": "", "medicineName": "SELECIONE O MEDICAMENTO"}];
  String _mySelection = '';
  String medicineInfoUrl = 'https://health-system-qrcode.herokuapp.com/medicine-list-name';
  
  Future<String> _getStateList() async {
    await http.get(Uri.parse(medicineInfoUrl) ).then((response) {
      var data = json.decode(response.body);
      dataList = data;
      //_myJson.clear();
      for(var i = 0; i< dataList.length; i++) {
        Map medicamento = data.elementAt(i);
        //_mySelection = medicamento['medicineID'];
        _myJson.add(medicamento);
      }
      setState(() {
      });
    });
    return 'true';
  }

  _onClickRegister(BuildContext context) {
    if (IDController.text.isEmpty || apTimeController.text.isEmpty || descriptionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Todos os campos são obirgatórios!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    } else if (_mySelection == ''){
         showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Selecione o medicamento"),
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
        runMyRegister();
    }
  }

  runMyRegister() {
    register(IDController.text,_mySelection, apTimeController.text,descriptionController.text).then((value) {
      if (value == true) {
        registerAccepted();
      } else {
        registerDenied();
      }
    }, onError: (error) {
      return (error);
    });
  }

  registerAccepted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Tudo certo!"),
            content: const Text("Prescrição cadastrada com sucesso!"),
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

  registerDenied() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Erro"),
            content: const Text("O usuário não possui permição para prescrever medicamentos!"),
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

  @override
  void initState() {
    _getStateList();
    super.initState();
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
                    'Prescrição',
                    style: TextStyle(
                        color: Color.fromARGB(255, 4, 59, 82),
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: IDController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Paciente',
                  hintText: 'Entre com o ID do paciente',
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
              height: 55,
              width: 370,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Color.fromARGB(255, 159, 218, 231), borderRadius: BorderRadius.circular(5)),
              child:  DropdownButton<String>(
                value: _mySelection,
                isDense: true,
                hint:  Text("SELECIONE O MEDICAMENTO"),
                onChanged: (String? newValue) {

                  setState(() {
                    _mySelection = newValue!;
                  });
                },
                items: _myJson.map((Map map) {
                  return  DropdownMenuItem<String>(
                    value: map["medicineID"].toString(),
                    child:  Text(
                      map["medicineName"],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: false,
                controller: apTimeController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Tempo de aplicação',
                  hintText: 'Entre com o tempo de aplicação da medicação',
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
                controller: descriptionController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                  hintText: 'Entre com a descrição da prescrição',
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