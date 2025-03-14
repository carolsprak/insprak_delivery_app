class Activity {
  final int id;
  final String name;
  final String description;
  final Address? address;
  final int providerId;
  final List<Product> products;

  Activity({required this.id,required this.name, required this.description,
    required this.address, required this.providerId, required this.products});

  // Método para converter o JSON para o objeto Activity
  factory Activity.fromJson(Map<String, dynamic> json) {
    var addressJson = json['address'];
    List<Product> productsList = [];
    if (json['products'] != null) {
      productsList = List<Product>.from(json['products'].map((product) => Product.fromJson(product)));
    }

    return Activity(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description']?? "",
      address: addressJson != null ? Address.fromJson(addressJson) : null,
      providerId: json['providerId'] ?? 0 ,
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'providerId': providerId,
      'products': products,
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

class Product {
  final String name;
  final String description;
  final double price;

  Product({required this.name, required this.description, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
    );
  }
}

