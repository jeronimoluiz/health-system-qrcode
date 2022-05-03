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
      }else{
        return false;
      }
}

Future<bool> generate() async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/emergency-info-qrcode/' + globals.user), headers:{"x-access-token" : globals.token});
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        globals.QRb64= body['qrcode'];       
        return true;
      }else{
        return false;
      }
}

Future<bool> loadQR(String hsh) async{
  var response = 
      await http.get(Uri.parse('https://health-system-qrcode.herokuapp.com/emergency-info-qrcode-read/' + hsh), headers:{"x-access-token" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJlbmNvZGUiOnsidXNlciI6ImhvamUiLCJwd2hhc2giOiJlZjc5N2M4MTE4ZjAyZGZiNjQ5NjA3ZGQ1ZDNmOGM3NjIzMDQ4YzljMDYzZDUzMmNjOTVjNWVkN2E4OThhNjRmIiwidXNlclR5cGUiOiJkb2N0b3IifSwiZXhwIjoxNjUwOTgwNTU1LCJuYmYiOjE2NTA4OTQxNTV9.Y7RHHj6wyQSB8TghUn7aULNTmPDb1aameDTNQbUjKpKCytNpTmuDaT-PA6BgQadUd_ldmYNRl6_0aevs6msAZGq088nBzlFkM2BLvLXxlePTPpBNtTHhDUVb16SyyRWdhqgVDdWp_V7mByDW2mVXkyNqmGZB2rvxIV5TENFaY-Tm8q8IsCqCebHYWO0HTvTvylIoGk-n5NXzuzl_Po9P9xtKm5kto92_g9h4WTYRcxTBG2ZYIrIs4bWXHAO5pNPK3HnAKJiTEDPrQ4IATlbOh956yAWtmQxPaAjst9hABUeuFCjmdclJKSz3FjcPG8yaqOMjXXDIsdQXa4M6VQJr2Q"});
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