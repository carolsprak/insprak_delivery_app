import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insprak_delivery_app/model/activity.dart';

import 'menu.dart'; // Para manipular os dados JSON

class EventScreen extends StatefulWidget {
  final int userId; // ID do usuário

  EventScreen({required this.userId}); // Construtor

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List< Activity> atividades = []; // Lista de atividades

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Carregar atividades da API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insprak Delivery", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[400],
      ),
      body: Scaffold(
        backgroundColor: Color(0xFFefefef),
        body: Column(
          children: <Widget>[
            Flexible(flex: 0, child: Container(width: 0.0, height: 0.0)),
            Flexible(
              flex: 1,
              child: atividades.isNotEmpty
                  ? _listagem(context)
                  : Center(child: Text("Não há restaurantes cadastrados!")),
            ),
          ],
        ),
      ),
      drawer: Menu(userId: widget.userId),
    );
  }

  // Função para buscar atividades da API REST
  Future<void> _fetchActivities() async {
    final response = await http.get(Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/restaurants'));

        if (response.statusCode == 200) {
          // Decodificar a resposta JSON em uma lista
          List<dynamic> data = json.decode(response.body);

          // Verificar o conteúdo da lista
          print(data);

          // Usar o setState para atualizar a lista de atividades
          setState(() {
            // Mapeando cada item da lista para o objeto Activity
            atividades = data.map((item) => Activity.fromJson(item)).toList();

        // Verificar a lista de atividades após o mapeamento
        print(atividades);
      });
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  Widget _listagem(BuildContext context) {
    return ListView.builder(
      itemCount: atividades.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 25,
                child: Text(
                  "${atividades[index].description.substring(0, 1)}",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
              title: Text(
                "${atividades[index].name}",
                style: TextStyle(
                    color: Colors.brown),
              ),
              subtitle: Text(
                  "${atividades[index].description}"),
            ),
          ),
        );
      },
    );
  }
}
