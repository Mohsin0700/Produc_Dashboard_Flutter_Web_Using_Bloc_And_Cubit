import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int skip = 0, int limit = 30});
  Future<Product> getProductById(int id);
  Future<Product> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(int id);
  Future<List<String>> getCategories();
}
