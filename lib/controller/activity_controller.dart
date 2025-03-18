import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insprak_delivery_app/model/activity.dart';

class ActivityController extends StatefulWidget {
  @override
  _ActivityControllerState createState() => _ActivityControllerState();

  // Substituindo Firebase por API REST
  Future<List<Activity>> getAllActivities(String table) async {
    return createState()._getAllActivities(table);
  }

  void addActivity(String table, Object data) async {
    await createState()._addActivity(table, data);
  }

  void updateActivity(String table, Object data) async {
    await createState()._updateActivity(table, data);
  }

  void deleteActivity(String table, String value) async {
    await createState()._deleteActivity(table, value);
  }
}

class _ActivityControllerState extends State<ActivityController> {


  final String apiUrl = 'https://insprak-delivery-api-3-388c3302da22.herokuapp.com/restaurants';

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // Método para pegar todas as atividades via API REST
  Future<List<Activity>> _getAllActivities(String table) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Activity> atividades = data
            .map((item) => Activity.fromJson(item))
            .toList();
        return atividades;
      } else {
        throw Exception('Falha ao carregar restaurantes');
      }
    } catch (e) {
      throw Exception('Erro ao buscar restaurantes: $e');
    }
  }

  // Método para adicionar atividade via API REST
  Future<void> _addActivity(String table, Object data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode((data as Activity).toJson()),
      );
      if (response.statusCode == 201) {
        // A atividade foi criada com sucesso
      } else {
        throw Exception('Erro ao adicionar restaurante');
      }
    } catch (e) {
      throw Exception('Erro ao adicionar restaurante: $e');
    }
  }

  // Método para atualizar atividade via API REST
  Future<void> _updateActivity(String table, Object data) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${(data as Activity).id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Erro ao atualizar restaurante');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar restaurante: $e');
    }
  }

  // Método para excluir atividade via API REST
  Future<void> _deleteActivity(String table, String value) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$value'));
      if (response.statusCode != 200) {
        throw Exception('Erro ao excluir restaurante');
      }
    } catch (e) {
      throw Exception('Erro ao excluir restaurante: $e');
    }
  }
}

