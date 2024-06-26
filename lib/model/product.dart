class Product {
  final String thumbnail;
  final String title;
  final String description;
  final String brand;
  final num price;
  final num discountPercentage;
  final num rating;
  final String availabilityStatus;
  final List<String> images;

  int productInfoIncValue = 1;


  Product({
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.availabilityStatus,
    required this.images,
  });

  factory Product.fromMap(Map productMap) {
    return Product(
      thumbnail: productMap['thumbnail'] ?? '',
      title: productMap['title'] ?? '',
      description: productMap['description'] ?? '',
      price: productMap['price'] ?? 0,
      discountPercentage: productMap['discountPercentage'] ?? 0,
      rating: productMap['rating'] ?? 0,
      brand: productMap['brand'] ?? 'Groceries',
      availabilityStatus: productMap['availabilityStatus'] ?? '',
      images: productMap['images'].cast<String>(),
    );
  }
}
