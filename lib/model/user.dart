class User {
  int id;
  String firstName;
  String username;
  String email;
  String password;

  User(this.id, this.firstName, this.username, this.email, this.password);

  // Construtor para criar um objeto User a partir de um JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] ?? '',
      json['firstName'] ?? '',
      json['username'] ?? '',
      json['email'] ?? '',
      json['password'] ?? '',
    );
  }

  // Converte o objeto User para um JSON (útil para envio via API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
