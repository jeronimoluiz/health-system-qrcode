import 'package:healthcare_system_qrcode/main.dart';
import 'package:http/http.dart' as http;

Future<bool> register(String cpf, String name, String password, String type) async{
  if (type == "Paciente"){
      type = "patient";
  }else if(type == "Médico"){
      type = "doctor";
  }else if (type == "Socorrista"){
      type = "rescuer";
  }

  var response = 
      await http.post(Uri.parse('https://health-system-qrcode.herokuapp.com/register'),body: {"user": cpf, "username": name, "pw": password, "userType": type});
      if(response.statusCode == 201){
        return true;
      }else{
        return false;        
      }
}