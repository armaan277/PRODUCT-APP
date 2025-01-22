import 'dart:convert';

class Product {
  final int id;
  final String thumbnail;
  final String title;
  final String description;
  final String brand;
  final double price;
  final num discountPercentage;
  final num rating;
  final String availabilityStatus;
  final List<String> images;
  final String returnPolicy;
  final String warrantyInformation;
  final String category;
  int quantity = 1;

  Product({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.availabilityStatus,
    required this.images,
    required this.returnPolicy,
    required this.warrantyInformation,
    required this.category,
    this.quantity = 1,
  });

  Map productToMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'price': price,
      'discountpercentage': discountPercentage,
      'rating': rating,
      'brand': brand,
      'availabilitystatus': availabilityStatus,
      'images': images,
      'returnpolicy': returnPolicy,
      'warrantyinformation': warrantyInformation,
      'category': category,
      'quantity': quantity,
    };
  }

  String toJson() {
    return jsonEncode(productToMap());
  }

  factory Product.fromMap(Map<String, dynamic> productMap) {
    return Product(
      id: int.tryParse(productMap['id'].toString()) ?? 0, // Convert to int
      thumbnail: productMap['thumbnail'] ?? '',
      title: productMap['title'] ?? '',
      description: productMap['description'] ?? '',
      price: double.tryParse(productMap['price'].toString()) ??
          0.0, // Convert to double
      discountPercentage:
          num.tryParse(productMap['discountpercentage'].toString()) ?? 0.0,
      rating: num.tryParse(productMap['rating'].toString()) ?? 0.0,
      brand: productMap['brand'] ?? 'Groceries',
      images: productMap['images'] is List
          ? List<String>.from(productMap['images'])
          : [], // Handle null or non-list 'images'
      availabilityStatus: productMap['availabilitystatus'] ?? '',
      returnPolicy: productMap['returnpolicy'] ?? '',
      warrantyInformation: productMap['warrantyinformation'] ?? '',
      category: productMap['category'] ?? '',
      quantity: productMap['quantity'] ?? 1,
    );
  }

  factory Product.fromJson(String json) {
    return Product.fromMap(jsonDecode(json));
  }

  @override
  bool operator ==(covariant Product other) => other.id == id;
}
