
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
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool cliente = false;
  bool prestador = false;
  bool entregador = false;
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
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Center(
                            child: Container(
                              width: 90, // Largura do container
                              height: 90, // Altura do container
                              decoration: BoxDecoration(
                                border: Border.all( // Define a borda
                                  color: Colors.transparent, // Cor da borda
                                  width: 3, // Largura da borda
                                ),
                                borderRadius: BorderRadius.circular(12), // Borda arredondada
                              ),
                              child: ClipRRect( // Garante que a imagem respeite o arredondamento
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.cover, // Ajusta a imagem dentro do container
                                ),
                              ),
                            ))),
                    Flexible(
                      child: TextFormField(
                        maxLength: 100,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            hintText: "Nome Completo"
                        ),
                        controller: _name,
                        keyboardType: TextInputType.text,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        maxLength: 100,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            hintText: "Usuário"
                        ),
                        controller: _username,
                        keyboardType: TextInputType.text,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        maxLength: 100,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            hintText: "Senha"),
                        controller: _password,
                        keyboardType: TextInputType.text,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
                        children: [
                          CheckboxListTile(
                            title: Text("Cliente", style: TextStyle(fontSize: 14)),
                            value: cliente,
                            onChanged: (bool? newValue) {
                              setState(() {
                                cliente = newValue!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          CheckboxListTile(
                            title: Text("Prestador", style: TextStyle(fontSize: 14)),
                            value: prestador,
                            onChanged: (bool? newValue) {
                              setState(() {
                                prestador = newValue!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          CheckboxListTile(
                            title: Text("Entregador", style: TextStyle(fontSize: 14)),
                            value: entregador,
                            onChanged: (bool? newValue) {
                              setState(() {
                                entregador = newValue!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: ElevatedButton(
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
      ),
    );
  }

  void _cadastraUsuario(GlobalKey<ScaffoldState> globalKey) async {
    List<String> profiles = getSelectedOptions();
    print(profiles); // Mostra no console os itens marcados

    User user = User(firstName: _firstName(_name.text),
        lastName: _lastName(_name.text),
        username: _username.text,
        password:_password.text,
        email: _email.text,
        profiles: profiles );

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

  String _firstName(String text) {
    List<String> parts = text.trim().split(" ");
    return parts.isNotEmpty ? parts[0] : "";
  }

  String _lastName(String text) {
    List<String> parts = text.trim().split(" ");
    return parts.length > 1 ? parts.sublist(1).join(" ") : "";
  }

  List<String> getSelectedOptions() {
    List<String> selectedOptions = [];

    if (cliente) selectedOptions.add("Cliente");
    if (prestador) selectedOptions.add("Prestador");
    if (entregador) selectedOptions.add("Entregador");

    return selectedOptions;
  }
}
