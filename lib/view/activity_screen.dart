
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insprak_delivery_app/model/activity.dart';

import 'menu.dart';

class ActivityScreen extends StatefulWidget {
  final int userId; // ID do usuário

  ActivityScreen({required this.userId}); // Construtor

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  List<Address> _address = [];
  List<Product> _products = [];

  List<Activity> atividades = [];

  @override
  void initState() {
    super.initState();
    _loadActivitiesByUser();
  }

  Future<void> _loadActivitiesByUser() async {
    try {
      final response = await http.get(Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/restaurants?providerId=${widget.userId}'));

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

  Future<void> _deleteActivity(int id) async {
    try {
      final response = await http.delete(Uri.parse('https://insprak-delivery-api-3-388c3302da22.herokuapp.com/restaurants/$id'));

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

  void _showDeleteDialog(int activityId) {
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
              subtitle: Text('${activity.description}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(activity.id),
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
          title: Text('Dados do restaurante'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _name,
                decoration: InputDecoration(hintText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _description,
                decoration: InputDecoration(hintText: 'Descrição'),
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
                        name: _name.text,
                        description: _description.text,
                        address: null,
                        providerId:  widget.userId,
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
        _loadActivitiesByUser();
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
        title: Text("Cadastrar Restaurantes", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[400],
      ),
      body: _buildActivityList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.brown[400],
        onPressed: _addActivity,
      ),
      drawer: Menu(userId: widget.userId),
    );
  }
}
