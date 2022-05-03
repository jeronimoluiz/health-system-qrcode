//import 'dart:html';

import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'package:healthcare_system_qrcode/globals.dart' as globals;

Future<bool> login(String user, String password) async{
  var response = 
      await http.post(Uri.parse('https://health-system-qrcode.herokuapp.com/login'),body: {"user": user,"pw": password});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.token = body['access_token'];
        globals.user = user;
        return true;
      }else{
        return false;
      }
}