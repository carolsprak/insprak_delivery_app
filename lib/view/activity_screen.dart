
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insprak_delivery_app/model/activity.dart';

import 'menu.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  final TextEditingController _palestra = TextEditingController();
  final TextEditingController _palestrante = TextEditingController();
  final TextEditingController _horario = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  List<Address> _address = [];
  List<Product> _products = [];

  List<Activity> atividades = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final response = await http.get(Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/restaurants'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          atividades = data.map((item) => Activity.fromJson(item)).toList();
        });
      } else {
        throw Exception('Falha ao carregar restaurantes');
      }
    } catch (error) {
      debugPrint(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar restaurante')));
    }
  }

  Future<void> _deleteActivity(String id) async {
    try {
      final response = await http.delete(Uri.parse('https://sua-api.com/activities/$id'));

      if (response.statusCode == 200) {
        setState(() {
          atividades.removeWhere((activity) => activity.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Restaurante removido com sucesso')));
      } else {
        throw Exception('Falha ao excluir o restaurante');
      }
    } catch (error) {
      debugPrint(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao remover restaurante')));
    }
  }

  void _showDeleteDialog(String activityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover Restaurante'),
          content: Text('Você deseja remover este restaurante?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _deleteActivity(activityId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      itemCount: atividades.length,
      itemBuilder: (context, index) {
        final activity = atividades[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon( Icons.check),
              title: Text(activity.name),
              subtitle: Text('${activity.description}\n${activity.providerId}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(activity.id as String),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addActivity() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Form(
        key: formKey,
        child: SimpleDialog(
          backgroundColor: Colors.white,
          title: Text('Carrinho de compras'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _palestra,
                decoration: InputDecoration(hintText: 'Restaurante'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _palestrante,
                decoration: InputDecoration(hintText: 'Produto'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _horario,
                decoration: InputDecoration(hintText: 'Quantidade'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: TextStyle(color: Colors.brown[400])),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newActivity = Activity(
                        id: 0,
                        name: _palestra.text,
                        description: _palestrante.text,
                        address: null,
                        providerId: int.parse(_horario.text),
                        products: _products,
                      );
                      await _createActivity(newActivity);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('OK', style: TextStyle(color: Colors.brown[400])),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createActivity(Activity activity) async {
    try {
      final response = await http.post(
        Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/restaurants'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(activity.toJson()),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Restaurante cadastrado com sucesso')));
        _loadActivities();
      } else {
        throw Exception('Falha ao criar restaurante');
      }
    } catch (error) {
      debugPrint(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar restaurante')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("CARRINHO", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[400],
      ),
      body: _buildActivityList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.brown[400],
        onPressed: _addActivity,
      ),
      drawer: Menu(),
    );
  }
}
