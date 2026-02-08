import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String description;
  final String? imageUrl;
  final double? rating;
  final String? brand;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
    this.imageUrl,
    this.rating,
    this.brand,
  });

  bool get isInStock => stock > 0;
  String get stockStatus => isInStock ? 'In Stock' : 'Out of Stock';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['title'] ?? json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['thumbnail'] ?? json['image'],
      rating: json['rating']?.toDouble(),
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'price': price,
      'stock': stock,
      'description': description,
      'thumbnail': imageUrl,
      'rating': rating,
      'brand': brand,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    int? stock,
    String? description,
    String? imageUrl,
    double? rating,
    String? brand,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      brand: brand ?? this.brand,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    price,
    stock,
    description,
    imageUrl,
    rating,
    brand,
  ];
}
