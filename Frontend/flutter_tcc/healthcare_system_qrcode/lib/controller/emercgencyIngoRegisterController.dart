import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'dart:io' as Io;

Future<bool> register(String name, String adress, String bloodType, String healthInfo, String organDonor, String contact) async{
  var response = 
      await http.post(Uri.parse('https://health-system-qrcode.herokuapp.com/emergency-info-register'), headers:{"x-access-token" : globals.token} , body: {"user": globals.user, "name": name, "address": adress, "bloodType": bloodType, "healthInfo": healthInfo, "organDonor": organDonor, "emergencyContact": contact });
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
}

Future<bool> load() async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/emergency-info/' + globals.user), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.nome = body['name'];
        globals.adress = body['address'];
        globals.bloodType = body['bloodType'];
        globals.emergencyContact = body['emergencyContact'];
        globals.healthInfo = body['healthInfo'];
        globals.organDonor = body['organDonor'];
        return true;
      }else if(response.statusCode == 404){
        globals.nome = '';
        globals.adress = '';
        globals.bloodType = '';
        globals.emergencyContact = '';
        globals.healthInfo = '';
        globals.organDonor = '';
        return true;
      }else{
        return false;
      }
}

Future<bool> generate() async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/emergency-info-qrcode/' + globals.user), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.QREmergencyb64= body['qrcode'];       
        return true;
      }else{
        return false;
      }
}

Future<bool> loadQR(String hsh) async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/emergency-info-qrcode-read/' + hsh), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        var emergencyInfo = body['emergencyInfo'];
        globals.nome = emergencyInfo['name'];
        globals.adress = emergencyInfo['address'];
        globals.bloodType = emergencyInfo['bloodType'];
        globals.emergencyContact = emergencyInfo['emergencyContact'];
        globals.healthInfo = emergencyInfo['healthInfo'];
        globals.organDonor = emergencyInfo['organDonor'];
        return true;
      }else{
        return false;
      }
}