import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthcare_system_qrcode/controller/prescriptionRegister.controller.dart';
import 'package:healthcare_system_qrcode/views/home.view.dart';
import 'package:healthcare_system_qrcode/controller/medicineQR.controller.dart';
import 'package:healthcare_system_qrcode/views/medicineQRExibition.view.dart';

class medicineQRRoute extends StatefulWidget {
  const medicineQRRoute({Key? key}) : super(key: key);

  @override
  _medicineQRRoute createState() => _medicineQRRoute();
}

class _medicineQRRoute extends State<medicineQRRoute> {
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


  _onClickGenarateMedicineQR(BuildContext context) {
    if (_mySelection != "") {
      generateMedicineQR(_mySelection).then((value) {
        if (value == true) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const medicineQRExibitionRoute()),
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
    } else{
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text("Erro"),
                content: const Text("Favor selecionar algum medicamento!"),
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
        title: const Text('Gerar QR Medicamento'),
      ),
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[  
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
                  child: const Text('Gerar'),
                  onPressed: () {
                    _onClickGenarateMedicineQR(context);
                  },
                )),
          ],
        ),
        ),
      ),
    );
  }
  }