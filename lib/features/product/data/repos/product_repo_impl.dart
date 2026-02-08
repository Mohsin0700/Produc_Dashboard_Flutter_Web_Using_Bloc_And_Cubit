import 'package:job_task/features/product/data/datasources/product_remote_datasources.dart';
import 'package:job_task/features/product/domain/repos/product_repo.dart';

import '../../domain/models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts({int skip = 0, int limit = 30}) async {
    return await remoteDataSource.getProducts(skip: skip, limit: limit);
  }

  @override
  Future<Product> getProductById(int id) async {
    return await remoteDataSource.getProductById(id);
  }

  @override
  Future<Product> addProduct(Product product) async {
    return await remoteDataSource.addProduct(product);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    return await remoteDataSource.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(int id) async {
    return await remoteDataSource.deleteProduct(id);
  }

  @override
  Future<List<String>> getCategories() async {
    return await remoteDataSource.getCategories();
  }
}
