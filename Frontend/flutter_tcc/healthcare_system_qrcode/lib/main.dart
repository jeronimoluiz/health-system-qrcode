import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/controller/emercgencyIngoRegisterController.dart';
import 'package:healthcare_system_qrcode/controller/login.controller.dart';
import 'package:healthcare_system_qrcode/controller/register.controller.dart';
import 'package:healthcare_system_qrcode/views/register.view.dart';
import 'views/qrCodeReading.view.dart';
import 'views/home.view.dart';
import 'qrcode.dart' as scanner; 
import 'package:healthcare_system_qrcode/globals.dart' as globals;
import 'package:healthcare_system_qrcode/views/emergencyInfo.view.dart';
import 'package:healthcare_system_qrcode/views/medicineRegister.view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const primaryColor = Color.fromARGB(255, 0, 184, 153);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 4, 148, 148),
        ),
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  String ticket = '';

  void initState() {
    _passwordVisible = false;
  }

  _onClickQrCode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrCodeRoute()),
    );
  }
  
  loginAccepted() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeRoute()),
    );
  }

  loginDenied() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Usuário ou senha incorretos!"),
            actions: <Widget>[
              TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ]);
      },
    );
  }

  runMyLogin() {
    login(nameController.text, passwordController.text).then((value) {
      if (value == true) {
        loginAccepted();
      } else {
        loginDenied();
      }
    }, onError: (error) {
      return (error);
    });
  }

   _onClickLoadQR(String hsh) {
    loadQR(hsh).then((value) {
      if (value == true) {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmergencyInfoRoute()),
        );
      } else {
       showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Houve algum erro, contacte o suporte!"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
      }
    }, onError: (error) {
      return (error);
    });    
  }

  runMyScanner(BuildContext context) {
    scanner.readQRCode().then((value) {
      if (value == '-1') {
        log('error');
      } else {
        _onClickLoadQR(value);
      }
    }, onError: (error) {
      return (error);
    });
  }


  _onClickLogin(BuildContext context) {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Usuário e/ou Senha inválido(s)"),
              actions: <Widget>[
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    } else {
      runMyLogin();
    }
  }

  _onClickRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: prefer_const_constructors

              Container(
                height: 125.0,
                width: 145.52,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logopr.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                        color: Color.fromARGB(255, 4, 59, 82),
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  autofocus: false,
                  controller: nameController,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 159, 218, 231),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Usuário',
                    hintText: 'Entre com o seu usuário',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                    ),
                    // labelStyle: TextStyle(
                    //color: Colors.white,
                    // )
                  ),
                  //style: (
                  //TextStyle(color: Colors.white)
                  // ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: !_passwordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    fillColor: Color.fromARGB(255, 159, 218, 231),
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    hintText: 'Entre com a sua senha',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 0, 184, 153)),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  '',
                ),
              ),
              Container(
                  height: 50,
                  width: 500,
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ))),
                    child: const Text('Login'),
                    onPressed: () {
                      _onClickLogin(context);
                    },
                  )),
              Container(
                height: 50,
                width: 500,
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: TextButton(
                  onPressed: () {
                    _onClickRegister(context);
                  },
                  child: const Text('Cadastre-se'),
                ),
              ),
              SizedBox(height: 60),
              Container(
                  height: 50,
                  width: 500,
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )),
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 209, 0, 0)),
                    ),
                    child: const Text('Dados Emergenciais'),
                    onPressed: () {
                      runMyScanner(context);
                      //_onClickQrCode(context);

                    },
                  )),
            ],
          ),
        ),
      ),

      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
