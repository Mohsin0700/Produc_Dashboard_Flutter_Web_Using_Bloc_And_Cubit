import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_task/features/product/domain/repos/product_repo.dart';
import '../../domain/models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterProductsEvent>(_onFilterProducts);
    on<SortProductsEvent>(_onSortProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<LoadProductDetailsEvent>(_onLoadProductDetails);
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts(limit: 30);
      final categories = await repository.getCategories();

      emit(
        ProductLoaded(
          products: products,
          filteredProducts: products,
          categories: categories,
          currentPage: 1,
          hasMore: products.length >= 30,
        ),
      );
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (!currentState.hasMore) return;

      try {
        final newProducts = await repository.getProducts(
          skip: currentState.currentPage * 30,
          limit: 30,
        );

        final allProducts = [...currentState.products, ...newProducts];
        final filteredProducts = _applyFilters(
          allProducts,
          currentState.searchQuery,
          currentState.selectedCategory,
          currentState.inStockOnly,
        );

        emit(
          currentState.copyWith(
            products: allProducts,
            filteredProducts: filteredProducts,
            currentPage: currentState.currentPage + 1,
            hasMore: newProducts.length >= 30,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to load more products: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filteredProducts = _applyFilters(
        currentState.products,
        event.query,
        currentState.selectedCategory,
        currentState.inStockOnly,
      );

      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          searchQuery: event.query,
        ),
      );
    }
  }

  Future<void> _onFilterProducts(
    FilterProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filteredProducts = _applyFilters(
        currentState.products,
        currentState.searchQuery,
        event.category,
        event.inStockOnly,
      );

      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          selectedCategory: event.category,
          inStockOnly: event.inStockOnly,
        ),
      );
    }
  }

  Future<void> _onSortProducts(
    SortProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final sortedProducts = List<Product>.from(currentState.filteredProducts);

      sortedProducts.sort((a, b) {
        int comparison;
        switch (event.sortBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'price':
            comparison = a.price.compareTo(b.price);
            break;
          case 'stock':
            comparison = a.stock.compareTo(b.stock);
            break;
          default:
            comparison = a.id.compareTo(b.id);
        }
        return event.ascending ? comparison : -comparison;
      });

      emit(currentState.copyWith(filteredProducts: sortedProducts));
    }
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        final newProduct = await repository.addProduct(event.product);
        final updatedProducts = [newProduct, ...currentState.products];
        final filteredProducts = _applyFilters(
          updatedProducts,
          currentState.searchQuery,
          currentState.selectedCategory,
          currentState.inStockOnly,
        );

        emit(
          currentState.copyWith(
            products: updatedProducts,
            filteredProducts: filteredProducts,
          ),
        );
        emit(const ProductOperationSuccess('Product added successfully'));

        emit(
          currentState.copyWith(
            products: updatedProducts,
            filteredProducts: filteredProducts,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to add product: ${e.toString()}'));
        emit(currentState);
      }
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        final updatedProduct = await repository.updateProduct(event.product);
        final updatedProducts = currentState.products.map((p) {
          return p.id == updatedProduct.id ? updatedProduct : p;
        }).toList();

        final filteredProducts = _applyFilters(
          updatedProducts,
          currentState.searchQuery,
          currentState.selectedCategory,
          currentState.inStockOnly,
        );

        emit(
          currentState.copyWith(
            products: updatedProducts,
            filteredProducts: filteredProducts,
          ),
        );
        emit(const ProductOperationSuccess('Product updated successfully'));

        emit(
          currentState.copyWith(
            products: updatedProducts,
            filteredProducts: filteredProducts,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to update product: ${e.toString()}'));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        await repository.deleteProduct(event.productId);
        final updatedProducts = currentState.products
            .where((p) => p.id != event.productId)
            .toList();

        final filteredProducts = _applyFilters(
          updatedProducts,
          currentState.searchQuery,
          currentState.selectedCategory,
          currentState.inStockOnly,
        );

        emit(
          currentState.copyWith(
            products: updatedProducts,
            filteredProducts: filteredProducts,
          ),
        );
        emit(const ProductOperationSuccess('Product deleted successfully'));

        emit(
          currentState.copyWith(
            products: updatedProducts,
            filteredProducts: filteredProducts,
          ),
        );
      } catch (e) {
        emit(ProductError('Failed to delete product: ${e.toString()}'));
        emit(currentState);
      }
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final product = await repository.getProductById(event.productId);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductError('Failed to load product details: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        final categories = await repository.getCategories();
        emit(currentState.copyWith(categories: categories));
      } catch (e) {
        // Silently fail
      }
    }
  }

  List<Product> _applyFilters(
    List<Product> products,
    String searchQuery,
    String? category,
    bool? inStockOnly,
  ) {
    var filtered = products;

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (category != null && category.isNotEmpty && category != 'All') {
      filtered = filtered.where((p) => p.category == category).toList();
    }

    if (inStockOnly == true) {
      filtered = filtered.where((p) => p.isInStock).toList();
    }

    return filtered;
  }
}
