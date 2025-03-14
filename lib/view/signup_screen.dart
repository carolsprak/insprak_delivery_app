
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import '../model/user.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
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
                          hintText: "Nome"
                      ),
                      controller: _firstName,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      maxLength: 100,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      controller: _email,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      maxLength: 20,
                      decoration: InputDecoration(hintText: "Senha"),
                      controller: _password,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      child: Text("Cadastrar"),
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
                        _cadastraUsuario(globalKey);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _cadastraUsuario(GlobalKey<ScaffoldState> globalKey) async {
    User user = User(0, _firstName.text, _username.text, _email.text,
        _convertToMd5(_password.text));
    if (formKey.currentState!.validate()) {
      ApiResponse response = await UserController().adicionarParticipante(
          user, formKey);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.msg)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Não foi possível cadastrar usuário.")),
        );
      }
    }

  }

  String _convertToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }
}
