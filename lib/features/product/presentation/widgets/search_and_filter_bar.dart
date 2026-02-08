import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class SearchAndFilterBar extends StatefulWidget {
  const SearchAndFilterBar({super.key});

  @override
  State<SearchAndFilterBar> createState() => _SearchAndFilterBarState();
}

class _SearchAndFilterBarState extends State<SearchAndFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  bool _inStockOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final categories = state is ProductLoaded
            ? state.categories
            : <String>[];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCategoryFilter(categories)),
                        const SizedBox(width: 12),
                        _buildStockFilter(),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 2, child: _buildSearchField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCategoryFilter(categories)),
                  const SizedBox(width: 16),
                  _buildStockFilter(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<ProductBloc>().add(
                    const SearchProductsEvent(''),
                  );
                },
              )
            : null,
      ),
      onChanged: (value) {
        context.read<ProductBloc>().add(SearchProductsEvent(value));
      },
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Categories')),
        ...categories.map((category) {
          return DropdownMenuItem(value: category, child: Text(category));
        }),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
        context.read<ProductBloc>().add(
          FilterProductsEvent(
            category: value,
            inStockOnly: _inStockOnly ? true : null,
          ),
        );
      },
    );
  }

  Widget _buildStockFilter() {
    return FilterChip(
      label: const Text('In Stock Only'),
      selected: _inStockOnly,
      onSelected: (selected) {
        setState(() {
          _inStockOnly = selected;
        });
        context.read<ProductBloc>().add(
          FilterProductsEvent(
            category: _selectedCategory,
            inStockOnly: selected ? true : null,
          ),
        );
      },
      avatar: Icon(
        _inStockOnly ? Icons.check_circle : Icons.filter_list,
        size: 18,
      ),
    );
  }
}
