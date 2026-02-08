import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/product.dart';

class ProductRemoteDataSource {
  final String baseUrl = 'https://dummyjson.com';

  // In-memory cache for added/updated products
  final Map<int, Product> _localProducts = {};
  int _nextId = 1000;

  Future<List<Product>> getProducts({int skip = 0, int limit = 30}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products?skip=$skip&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        // Add locally created products
        products.addAll(_localProducts.values);
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    if (_localProducts.containsKey(id)) {
      return _localProducts[id]!;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newProduct = product.copyWith(id: _nextId++);
        _localProducts[newProduct.id] = newProduct;
        return newProduct;
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      final newProduct = product.copyWith(id: _nextId++);
      _localProducts[newProduct.id] = newProduct;
      return newProduct;
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      if (_localProducts.containsKey(product.id)) {
        _localProducts[product.id] = product;
        return product;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200) {
        _localProducts[product.id] = product;
        return product;
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      _localProducts[product.id] = product;
      return product;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      _localProducts.remove(id);

      final response = await http.delete(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      return [
        'smartphones',
        'laptops',
        'fragrances',
        'skincare',
        'groceries',
        'home-decoration',
      ];
    }
  }
}
