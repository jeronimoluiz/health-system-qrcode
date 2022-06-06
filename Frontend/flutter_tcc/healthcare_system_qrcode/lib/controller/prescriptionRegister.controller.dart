import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'dart:io' as Io;

Future<bool> register(String patienteID, String medicineID, String aplicationTime, String description) async{
  var response = 
      await http.post(Uri.parse('https://health-system-qrcode.herokuapp.com/prescription-register'), headers:{"x-access-token" : globals.token} , body: {"patient_id": patienteID, "medicine_id": medicineID, "application_time": aplicationTime, "description": description });
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
}

Future<bool> validatePrescription(String validationCode) async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/validation-document/' + validationCode), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.actualPrescription = body['document'];       
        return true;
      }else{
        return false;
      }
}