import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/boasvindas_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Home Page', textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () async {
              bool saiu = await sair();
              if(saiu){
                Navigator.pushReplacement(
                    context,
                  MaterialPageRoute(
                    builder: (context) => BoasVindasPage(),
                  ),
                );
              }
            },
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }
  
  Future<bool> sair() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }
}