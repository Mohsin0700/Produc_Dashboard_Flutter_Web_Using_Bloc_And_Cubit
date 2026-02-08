import 'package:equatable/equatable.dart';
import '../../domain/models/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {}

class LoadMoreProductsEvent extends ProductEvent {}

class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterProductsEvent extends ProductEvent {
  final String? category;
  final bool? inStockOnly;

  const FilterProductsEvent({this.category, this.inStockOnly});

  @override
  List<Object?> get props => [category, inStockOnly];
}

class SortProductsEvent extends ProductEvent {
  final String sortBy;
  final bool ascending;

  const SortProductsEvent({required this.sortBy, required this.ascending});

  @override
  List<Object?> get props => [sortBy, ascending];
}

class AddProductEvent extends ProductEvent {
  final Product product;

  const AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final int productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class LoadProductDetailsEvent extends ProductEvent {
  final int productId;

  const LoadProductDetailsEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class LoadCategoriesEvent extends ProductEvent {}
