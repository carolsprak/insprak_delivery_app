

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
        title: Text("Insprak Delivery", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[400],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          maxLength: 100,
                          decoration: InputDecoration(hintText: "Nome de usuário"),
                          controller: _username,
                          keyboardType: TextInputType.text,
                          validator: (val) => val == null || val.isEmpty ? "Campo obrigatório" : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          obscureText: true,
                          maxLength: 20,
                          decoration: InputDecoration(hintText: "Senha"),
                          controller: _password,
                          keyboardType: TextInputType.text,
                          validator: (val) => val == null || val.isEmpty ? "Campo obrigatório" : null,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                child: Text("Entrar"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.brown[400],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  _login(context);
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextButton(
                                child: Text("Cadastrar"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.brown[400],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  void _login( BuildContext context) async {
    User user = User(
        firstName: '',
        username: _username.text,
        password:_password.text,
        email: '',
        profiles: []
    );

    if (formKey.currentState!.validate()) {
      ApiResponse response = await UserController().login(user, formKey);
      if (response != null && response.ok) {
        int userId = response.result['userId'];

        print(response.result['userId']);
        popMsg(context, response.msg);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventScreen(userId: userId)),
        );
      } else {
        popMsg(context, response.msg ?? "Não foi possível realizar o login.");

      }
    }
  }

  String _convertToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  void popMsg(BuildContext context, String msg) {
    final snackBar = SnackBar(
        content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
