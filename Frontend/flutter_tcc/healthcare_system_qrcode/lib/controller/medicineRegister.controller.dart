import 'package:http/http.dart' as http;
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'dart:convert';

Future<bool> register(String medicineID, String medicineName, String manufacturer, String expiration, String inventory) async{
  var response = 
      await http.post(Uri.parse('https://health-system-qrcode.herokuapp.com/medicine-register'),headers:{"x-access-token" : globals.token},body: {"medicine_id": medicineID,"medicine_name": medicineName,"manufacturer": manufacturer,"inventory": inventory,"expiration": expiration});
      if(response.statusCode == 200){
        return true;
      }else{
        return false;        
      }
}