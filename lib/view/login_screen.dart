

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:insprak_delivery_app/view/event_screen.dart';
import 'package:insprak_delivery_app/view/signup_screen.dart';

import '../controller/user_controller.dart';
import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      appBar: AppBar(
        title: Text("Insprak Delivery", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown[400],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            color: Colors.white,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Flexible(
                      flex: 1,
                      child: Center(
                          child: Image.asset("assets/images/logo.png",
                              width: 150.0, height: 150.0))),
                  Flexible(
                    child: TextFormField(
                      maxLength: 100,
                      decoration: InputDecoration(
                          hintText: "Username"
                      ),
                      controller: _username,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      maxLength: 20,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      controller: _password,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alinhamento dos botões
                    children: <Widget>[
                      Flexible(
                        child: TextButton(

                          child: Text("Entrar"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            // Cor do texto
                            backgroundColor: Colors.brown[400],
                            // Cor do botão
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            // Espaçamento interno
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Cantos arredondados
                            ),
                          ),
                          onPressed: () {
                            _login(globalKey, context);
                          },
                        ),
                      ),
                      Flexible(
                          child: TextButton(
                            child: Text("Cadastro"),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              // Cor do texto
                              backgroundColor: Colors.brown[400],
                              // Cor do botão
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              // Espaçamento interno
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Cantos arredondados
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder:
                                  (BuildContext context) => SignUpScreen()));
                            },)
                      ),
                    ]
                  )
                ],),
            ),
          ),
        ),
      ),
    );
  }

  void _login(GlobalKey<ScaffoldState> globalKey, BuildContext context) async {
    User user = User(0, '', '', '', null, firstName: '',
        username: _username.text, password:_password.text,email: '', profiles: [] );
    if (formKey.currentState!.validate()) {
      ApiResponse response = await UserController().login(user, formKey);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.msg)),
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Não foi possível realizar o login.")),
        );
      }
    }
  }

  String _convertToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }
}
