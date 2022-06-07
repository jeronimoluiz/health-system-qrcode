import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'dart:io' as Io;

Future<bool> generateMedicineQR(String medicineID) async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/medicine-qrcode/' + medicineID), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.QRActualMedicine= body['QRCode'];   
        return true;
      }else{
        return false;
      }
}