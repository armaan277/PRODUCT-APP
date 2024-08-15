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

  int productInfoIncValue = 1;

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
    this.productInfoIncValue = 1,
  });

  Map productToMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'brand': brand,
      'availabilityStatus': availabilityStatus,
      'images': images,
      'returnPolicy': returnPolicy,
      'warrantyInformation': warrantyInformation,
      'category': category,
      'productInfoIncValue': productInfoIncValue,
    };
  }

  String toJson() {
    return jsonEncode(productToMap());
  }

  factory Product.fromMap(Map productMap) {
    return Product(
      id: productMap['id'],
      thumbnail: productMap['thumbnail'] ?? '',
      title: productMap['title'] ?? '',
      description: productMap['description'] ?? '',
      price: productMap['price'] ?? 0,
      discountPercentage: productMap['discountPercentage'] ?? 0,
      rating: productMap['rating'] ?? 0,
      brand: productMap['brand'] ?? 'Groceries',
      availabilityStatus: productMap['availabilityStatus'] ?? '',
      images: productMap['images'].cast<String>(),
      returnPolicy: productMap['returnPolicy'] ?? '',
      warrantyInformation: productMap['warrantyInformation'] ?? '',
      category: productMap['category'] ?? '',
      productInfoIncValue: productMap['productInfoIncValue'] ?? 1,
    );
  }

  factory Product.fromJson(String json) {
    return Product.fromMap(jsonDecode(json));
  }

  @override
  bool operator == (covariant Product other) =>  other.id == id;
}
