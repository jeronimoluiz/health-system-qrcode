import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teste/home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail'
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email){
                      if(email == null || email.isEmpty){
                        return 'Por favor, digite seu e-mail';
                      }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text)) {
                        return 'Por favor, digite um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Senha'
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (senha){
                      if(senha == null || senha.isEmpty){
                        return 'Por favor, digite sua senha';
                      }else if(senha.length < 6){
                        return 'Por favor, digite uma senha maior que 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if(_formkey.currentState!.validate()){
                      bool deuCerto = await login();

                      if(!currentFocus.hasPrimaryFocus){
                        currentFocus.unfocus();
                      }
                      if(deuCerto){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                        );
                      }else{
                        _passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                    }
                  }, child: Text('ENTRAR'),),
                ],
              ),
            )
        )

      ),
    );
  }

  final snackBar = SnackBar(
      content: Text(
        'E-mail ou senha inválidos',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.redAccent,
  );

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('http://192.168.15.4:5000/');
    // var resposta = await http.post(
    //     url,
    //     body: {
    //       'username': _emailController.text,
    //       'password': _passwordController.text
    //     },
    // );
    var resposta = await http.get(url);
    if(resposta.statusCode == 200){

      // Armazena o Token no armazenamento interno do app
      //await sharedPreferences.setString('token', "Token ${jsonDecode(resposta.body)['token']}");

      //print(jsonDecode(resposta.body));
      //print('Token: ' + jsonDecode(resposta.body)['token']);
      print(resposta.body);
      return true;
    }else{
      //print(jsonDecode(resposta.body));
      print(resposta);
      return false;
    }
  }
}


