import 'package:equatable/equatable.dart';
import '../../domain/models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final List<String> categories;
  final String? selectedCategory;
  final bool? inStockOnly;
  final String searchQuery;
  final bool hasMore;
  final int currentPage;

  const ProductLoaded({
    required this.products,
    required this.filteredProducts,
    this.categories = const [],
    this.selectedCategory,
    this.inStockOnly,
    this.searchQuery = '',
    this.hasMore = true,
    this.currentPage = 0,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
    bool? inStockOnly,
    String? searchQuery,
    bool? hasMore,
    int? currentPage,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    categories,
    selectedCategory,
    inStockOnly,
    searchQuery,
    hasMore,
    currentPage,
  ];
}

class ProductDetailsLoading extends ProductState {}

class ProductDetailsLoaded extends ProductState {
  final Product product;

  const ProductDetailsLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
