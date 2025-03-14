import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../model/user.dart';

class ApiResponse<T> {
  bool ok;
  String msg;
  T result;

  // Construtor para resposta de sucesso
  ApiResponse.ok({required this.result, required this.msg}) : ok = true;

  // Construtor para resposta de erro
  ApiResponse.error({required this.result, required this.msg}) : ok = false;
}


class UserController extends StatefulWidget {
  @override
  _UserControllerState createState() => _UserControllerState();

  Future<ApiResponse> adicionarParticipante(User user, GlobalKey<FormState> formKey) {
    return _UserControllerState()._cadastrar(user, formKey);
  }

  Future<ApiResponse> login(User user, GlobalKey<FormState> formKey) {
    return _UserControllerState()._login(user, formKey);
  }

  Future<void> logout() {
    return _UserControllerState()._logout();
  }
}

class _UserControllerState extends State<UserController> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  /// Simulação de logout (se precisar invalidar token futuramente)
  Future<void> _logout() async {
    // Aqui poderia limpar um token salvo no SharedPreferences
    print("Usuário deslogado");
  }

  /// **Login via API REST**
  Future<ApiResponse> _login(User user, GlobalKey<FormState> formKey) async {
    try {
      formKey.currentState?.save();
      formKey.currentState?.reset();

      final response = await http.post(
        Uri.parse('https://api.exemplo.com/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.ok(msg: "Login realizado com sucesso!", result: data);
      } else {
        return ApiResponse.error(msg: "Não foi possível realizar o login.", result: null);
      }
    } catch (error) {
      print("Erro na API: $error");
      return ApiResponse.error(msg: "Erro ao conectar-se ao servidor.", result: null);
    }
  }

  /// **Cadastro de usuário via API REST**
  Future<ApiResponse> _cadastrar(User user, GlobalKey<FormState> formKey) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.exemplo.com/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()), // Converte User para JSON
      );

      if (response.statusCode == 201) {
        return ApiResponse.ok(msg: "Usuário cadastrado com sucesso!", result: null);
      } else if (response.statusCode == 409) {
        return ApiResponse.error(msg: "Este e-mail já está cadastrado.", result: null);
      } else {
        return ApiResponse.error(msg: "Erro ao criar usuário.", result: null);
      }
    } catch (error) {
      print("Erro na API: $error");
      return ApiResponse.error(msg: "Não foi possível cadastrar o usuário.", result: null);
    }
  }
}


