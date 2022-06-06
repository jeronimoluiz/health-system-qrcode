import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:healthcare_system_qrcode/globals.dart' as globals;

Future<bool> validate(String QRcode_patient, String QRcode_employee, String QRcode_medicine) async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/flow-query/' + QRcode_patient + '/' + QRcode_employee + '/'  + QRcode_medicine ), headers: {"x-access-token" : globals.token});
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
}

Future<bool> register(String QRcode_patient, String QRcode_employee, String QRcode_medicine) async{
   var response = 
      await http.post(Uri.parse('https://health-system-qrcode.herokuapp.com/flow'), body: {"QRcode_patient":  QRcode_patient, "QRcode_employee": QRcode_employee , "QRcode_medicine": QRcode_medicine}, headers: {"x-access-token" : globals.token});
      if(response.statusCode == 200) {
        return true;
      }else{
        return false;
      }
}