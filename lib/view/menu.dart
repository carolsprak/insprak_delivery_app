
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insprak_delivery_app/controller/user_controller.dart';
import 'package:insprak_delivery_app/view/login_screen.dart';
import 'dart:convert';

import 'activity_screen.dart';
import 'event_screen.dart';

class Menu extends StatelessWidget {

  Future<Map<String, dynamic>> _getUserData() async {
    // Suponha que sua API retorne os dados do usuário autenticado
    final response = await http.get(Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/users'));
    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar dados do usuário');
    }
  }

  UserAccountsDrawerHeader _header(Map<String, dynamic> user) {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.orange[100],
        ),
        accountName: Text(user['firstName'] ?? ""),
        accountEmail: Text(user['email'] ?? ""),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 80,
          child: Text(
            "${user['name']?.substring(0, 1).toUpperCase() ?? "X"}",
            style: TextStyle(fontSize: 40.0, color: Colors.black54),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(' '),
                  );
                } else if (snapshot.hasData) {
                  Map<String, dynamic>? user = snapshot.data;
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
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EventScreen()));
              },
            ),
            ListTile(
              title: Text("Carrinho de compras"),
              leading: Icon(Icons.today),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ActivityScreen()));
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
