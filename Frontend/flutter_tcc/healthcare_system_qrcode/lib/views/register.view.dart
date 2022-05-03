import 'package:flutter/material.dart';
import 'package:healthcare_system_qrcode/controller/register.controller.dart';
import 'package:healthcare_system_qrcode/main.dart';

class RegisterRoute extends StatefulWidget {
  const RegisterRoute({Key? key}) : super(key: key);

  @override
  _RegisterRoute createState() => _RegisterRoute();
}

class _RegisterRoute extends State<RegisterRoute> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  String dropdownValue = 'Paciente';

   registerAccepted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Tudo certo!"),
            content: const Text("Usuário cadastrado com sucesso!"),
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

   registerDenied() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Erro"),
            content: const Text("Não foi possível cadastrar o usuário! Entre em contato com o suporte"),
            actions: <Widget>[
              TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                     Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)),
    );
                  })
            ]);
      },
    );
  }

  runMyRegister() {
    register(nameController.text, passwordController.text,dropdownValue).then((value) {
      if (value == true) {
        registerAccepted();
      } else {
        registerDenied();
      }
    }, onError: (error) {
      return (error);
    });
  }

  _onClickRegister(BuildContext context) {
    if (nameController.text.isEmpty || passwordController.text.isEmpty || passwordConfirmController.text.isEmpty) {
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
    } else if (passwordController.text != passwordConfirmController.text){
         showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Erro"),
              content: const Text("As senhas não conferem"),
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
        runMyRegister();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Usuário',
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
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
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
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: !_passwordConfirmVisible,
                controller: passwordConfirmController,
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
                        _passwordConfirmVisible = !_passwordConfirmVisible;
                      });
                    },
                  ),
                  fillColor: Color.fromARGB(255, 159, 218, 231),
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Confirmar Senha',
                  hintText: 'Digite sua senha novamente',
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
            SizedBox(height: 10),
            Container(
              height: 55,
              width: 370,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Color.fromARGB(255, 159, 218, 231), borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<String>(
                  value: dropdownValue,
                  // icon: const Icon(Icons.arrow_downward),
                  // elevation: 40,
                  // style: const TextStyle(color: Color.fromARGB(255, 159, 218, 231)),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Paciente', 'Médico', 'Socorrista']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ))),
                  child: const Text('Cadastrar'),
                  onPressed: () {
                    _onClickRegister(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
