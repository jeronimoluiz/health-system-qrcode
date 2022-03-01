import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/home_page.dart';
import 'package:teste/login_page.dart';


class BoasVindasPage extends StatefulWidget {
  const BoasVindasPage({ Key? key }) : super(key: key);

  @override
  _BoasVindasPageState createState() => _BoasVindasPageState();
}

class _BoasVindasPageState extends State<BoasVindasPage> {

  @override
  void initState() {
    super.initState();
    verificarToken().then((value) {
      if(value){
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }else{
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  Future<bool> verificarToken() async{
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if(sharedPreference.getString('token') == null){
      return false;
    }else{
      return true;
    }
  }


}