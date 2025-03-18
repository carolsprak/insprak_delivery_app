class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String email;
  final String cpfCnpj;
  final String birthDate;
  final List<String> profiles;
  final Address? address;

  User(this.id, this.lastName, this.cpfCnpj, this.birthDate, this.address,
      { required this.firstName, required this.username, 
  required this.password, required this.email,
    required this.profiles});

  // Construtor para criar um objeto User a partir de um JSON
  factory User.fromJson(Map<String, dynamic> json) {
    var addressJson = json['address'];

    return User(
      json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      json['lastName'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      json['cpfCnpj'] ?? '',
      json['birthDate'] ?? '',
      profiles: json['profiles'] ?? ["Cliente"],
      addressJson != null ? Address.fromJson(addressJson) : null,
    );
  }

  // Converte o objeto User para um JSON (útil para envio via API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'email': email,
      'cpfCnpj': cpfCnpj,
      'birthDate': birthDate,
      'profiles': profiles,
      'address': address
    };
  }
}

class Address {
  final String street;
  final String number;
  final String city;
  final String state;
  final String zipCode;

  Address({required this.street, required this.number, required this.city, required this.state, required this.zipCode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      number: json['number'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
    );
  }
}