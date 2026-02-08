import 'package:flutter/material.dart';
import '../../domain/models/product.dart';

class ProductTable extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function(Product) onEditProduct;
  final Function(Product) onDeleteProduct;

  const ProductTable({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onEditProduct,
    required this.onDeleteProduct,
  });

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  List<Product> _sortedProducts = [];

  @override
  void initState() {
    super.initState();
    _sortedProducts = List.from(widget.products);
  }

  @override
  void didUpdateWidget(ProductTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.products != oldWidget.products) {
      _sortedProducts = List.from(widget.products);
      _sort();
    }
  }

  void _sort() {
    setState(() {
      switch (_sortColumnIndex) {
        case 0:
          _sortedProducts.sort(
            (a, b) =>
                _sortAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id),
          );
          break;
        case 1:
          _sortedProducts.sort(
            (a, b) => _sortAscending
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name),
          );
          break;
        case 2:
          _sortedProducts.sort(
            (a, b) => _sortAscending
                ? a.category.compareTo(b.category)
                : b.category.compareTo(a.category),
          );
          break;
        case 3:
          _sortedProducts.sort(
            (a, b) => _sortAscending
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price),
          );
          break;
        case 4:
          _sortedProducts.sort(
            (a, b) => _sortAscending
                ? a.stock.compareTo(b.stock)
                : b.stock.compareTo(a.stock),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 800;

        if (isNarrow) {
          return _buildMobileList();
        } else {
          return _buildDataTable();
        }
      },
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: const Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                  });
                  _sort();
                },
              ),
              DataColumn(
                label: const Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                  });
                  _sort();
                },
              ),
              DataColumn(
                label: const Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                  });
                  _sort();
                },
              ),
              DataColumn(
                label: const Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                  });
                  _sort();
                },
              ),
              DataColumn(
                label: const Text(
                  'Stock',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                  });
                  _sort();
                },
              ),
              const DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: _sortedProducts.map((product) {
              return DataRow(
                cells: [
                  DataCell(
                    Text('#${product.id}'),
                    onTap: () => widget.onProductTap(product),
                  ),
                  DataCell(
                    Text(product.name),
                    onTap: () => widget.onProductTap(product),
                  ),
                  DataCell(
                    Chip(
                      label: Text(product.category),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () => widget.onProductTap(product),
                  ),
                  DataCell(
                    Text('\$${product.price.toStringAsFixed(2)}'),
                    onTap: () => widget.onProductTap(product),
                  ),
                  DataCell(
                    Text('${product.stock}'),
                    onTap: () => widget.onProductTap(product),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.isInStock
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.stockStatus,
                        style: TextStyle(
                          color: product.isInStock ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    onTap: () => widget.onProductTap(product),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => widget.onEditProduct(product),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => widget.onDeleteProduct(product),
                          tooltip: 'Delete',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sortedProducts.length,
      itemBuilder: (context, index) {
        final product = _sortedProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => widget.onProductTap(product),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: #${product.id}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: product.isInStock
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.stockStatus,
                          style: TextStyle(
                            color: product.isInStock
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        label: Text(product.category),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                      Chip(
                        label: Text('\$${product.price.toStringAsFixed(2)}'),
                        backgroundColor: Colors.grey[100],
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                      Chip(
                        label: Text('Stock: ${product.stock}'),
                        backgroundColor: Colors.grey[100],
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => widget.onEditProduct(product),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => widget.onDeleteProduct(product),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
