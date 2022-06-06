import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'dart:io' as Io;

Future<bool> generate(String medicineID) async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/prescription-pdf/' + globals.user  + '/' + medicineID), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.actualPrescription= body['prescriptionPDF'];   
        return true;
      }else{
        return false;
      }
}