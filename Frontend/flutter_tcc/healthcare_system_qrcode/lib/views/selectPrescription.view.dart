import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthcare_system_qrcode/controller/prescriptionRegister.controller.dart';
import 'package:healthcare_system_qrcode/views/home.view.dart';
import 'package:healthcare_system_qrcode/controller/medicineQR.controller.dart';
import 'package:healthcare_system_qrcode/views/medicineQRExibition.view.dart';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/views/prescriotionViewRoute.view.dart';

class selectPrescriptionRoute extends StatefulWidget {
  const selectPrescriptionRoute({Key? key}) : super(key: key);

  @override
  _selectPrescriptionRoute createState() => _selectPrescriptionRoute();
}

class _selectPrescriptionRoute extends State<selectPrescriptionRoute> {
  var dataList = [];
  List<Map> _myJson = [{"medicineID": "", "prescriptionName": "SELECIONE A PRESCRIÇÃO"}];
  String _mySelection = '';
  String prescriptionInfoUrl = 'https://health-system-qrcode.herokuapp.com/prescription/'+ globals.user;
  
    Future<String> _getStateList() async {
    await http.get(Uri.parse(prescriptionInfoUrl), headers:{"x-access-token" : globals.token} ).then((response) {
      var data = json.decode(response.body);
      dataList = data;
      for(var i = 0; i< dataList.length; i++) {
        Map prescription = data.elementAt(i);
        prescription.putIfAbsent("medicineID", () => data['medicineID']);
        prescription.putIfAbsent("prescriptionName", () => data['medicineID'] + '/' + data['prescriptionDate']);
        _myJson.add(prescription);
      }
      setState(() {
      });
    });
    return 'true';
  }


  _onClickPrescriptionView(BuildContext context){
    generateMedicineQR(_mySelection).then((value) {
      if(value == true){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => prescriptionViewRoute()),
        );
      }else{
        showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Houve um erro para recuperar o pdf dessa prescrição! Procure o suporte."),
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

  @override
  void initState() {
    //_getStateList();
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar prescrição'),
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
                hint:  Text("SELECIONE A PRESCRIÇÃO"),
                onChanged: (String? newValue) {

                  setState(() {
                    _mySelection = newValue!;
                  });
                },
                items: _myJson.map((Map map) {
                  return  DropdownMenuItem<String>(
                    value: map["medicineID"].toString(),
                    child:  Text(
                      map["prescriptionName"],
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
                  child: const Text('Vizualizar'),
                  onPressed: () {
                    _onClickPrescriptionView(context);
                  },
                )),
          ],
        ),
        ),
      ),
    );
  }
  }