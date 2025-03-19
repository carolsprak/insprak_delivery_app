
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insprak_delivery_app/controller/user_controller.dart';
import 'package:insprak_delivery_app/view/login_screen.dart';
import 'dart:convert';

import '../model/user.dart';
import 'activity_screen.dart';
import 'event_screen.dart';

class Menu extends StatefulWidget {
  final int userId; // ID do usuário

  Menu({required this.userId}); // Construtor

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  List<String> userProfiles = [];

  @override
  void initState() {
    super.initState();
    _getUserData(widget.userId); // Carregar usuario da API
    _loadUserProfiles(widget.userId);
  }

  Future<Map<String, dynamic>> _getUserData(userId) async {
    // Suponha que sua API retorne os dados do usuário autenticado
    final response = await http.get(Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/users/$userId'));
    //print(response.body);

    if (response.statusCode == 200) {

      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar dados do usuário');
    }
  }

  void _loadUserProfiles(userId) async {
    try {
      Map<String, dynamic> userData = await _getUserData(userId);

      userProfiles = userData['profiles'] ?? [];

      print('Perfis do usuário: $userProfiles');
    } catch (e) {
      print('Erro ao carregar perfis do usuário: $e');
    }
  }

  String _profilesNames(Map<String, dynamic> user) {
    List<String> profiles = List<String>.from(user['profiles'] ?? []);
    return profiles.isNotEmpty
        ? profiles.map((profile) => profile.toString().substring(0, 3).toUpperCase()).join(", ")
        : "";
  }

  UserAccountsDrawerHeader _header(Map<String, dynamic> user) {
    String name = user['firstName'] + " " + user['lastName'];
    String perfis = _profilesNames(user);
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.brown[400],
        ),
        accountName: Text(name  + ' (' + perfis + ')' ?? ""),
        accountEmail: Text(user['email'] ?? ""),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 80,
          child: Text(
            "${user['firstName']?.substring(0, 1).toUpperCase()?? "X"}",
            style: TextStyle(fontSize: 20.0, color: Colors.black54),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    int userId = 0;
    bool prestador = false;
    return SafeArea(
      child: Drawer(
        child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(' '),
                  );
                } else if (snapshot.hasData) {
                  Map<String, dynamic>? user = snapshot.data;
                  prestador = user?['profiles'].contains("Prestador") ?? false;
                  return _header(user!);
                } else {
                  return Container();
                }
              },
            ),
            ListTile(
              title: Text("Restaurantes"),
              leading: Icon(Icons.today),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                userId =  widget.userId;
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EventScreen(userId: widget.userId)));
              },
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("")); // Mostra carregamento
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erro ao carregar dados do usuário")); // Exibe erro
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("Usuário não encontrado")); // Trata resposta vazia
                }

                //   Obtém os perfis do usuário
                List<dynamic> profiles = snapshot.data!['profiles'] ?? [];

                //   Se for "Prestador", exibe o menu
                if (profiles.contains('Prestador')) {
                  return ListTile(
                    title: Text("Cadastrar restaurantes"),
                    leading: Icon(Icons.today),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActivityScreen(userId: widget.userId),
                        ),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink(); // Retorna um widget vazio se não for "Prestador"
                }
              },
            ),
            ListTile(
              title: Text("Sair"),
              leading: Icon(Icons.exit_to_app),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                UserController().logout();
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
              },
            )
          ],
        ),
      ),
      ),
    );
  }
}
