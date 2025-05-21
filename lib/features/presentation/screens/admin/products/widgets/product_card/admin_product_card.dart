import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

class AdminProductCard extends StatefulWidget {
  final ProductResponse product;
  const AdminProductCard({super.key, required this.product});

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  ProductResponse get product => widget.product;

  @override
  Widget build(BuildContext context) {
    bool lowStock = product.units!.any((unit) => unit.inStock! < 10);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: lowStock ? Colors.red.shade300 : Colors.transparent,
          width: lowStock ? 1 : 0,
        ),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (product.isActive == 1) ? Colors.green : Colors.red,
              ),
              margin: const EdgeInsets.only(right: 8),
            ),
            Expanded(
              child: Text(
                product.name!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          'ID: ${product.id} • Category: ${product.categoryId}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lowStock)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Tooltip(
                  message: 'Low stock',
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red[400],
                  ),
                ),
              ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // _showEditProductDialog(product);
                } else if (value == 'toggle') {
                  // _toggleProductStatus(product);
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle',
                      child: ListTile(
                        leading: Icon(
                          product.isActive == 1
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        title: Text(
                          product.isActive == 1 ? 'Deactivate' : 'Activate',
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Units',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...product.units!.map((unit) => _buildUnitRow(product, unit)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add Unit'),
                      onPressed: () {
                        // _showAddUnitDialog(product);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Product'),
                      onPressed: () {
                        // _showEditProductDialog(product);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitRow(ProductResponse product, ProductUnitResponse unit) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    bool isLowStock = unit.inStock! < 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${unit.name} (${unit.abbreviation})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (unit.isDefault == true)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                  ],
                ),
                Text('Conversion: ${unit.conversionFactor}'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('MRP: ₹${formatter.format(unit.mrp)}'),
                Text('SP: ₹${formatter.format(unit.sellingPrice)}'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (isLowStock)
                          Icon(Icons.warning, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock: ${unit.inStock}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isLowStock ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // _updateStock(product, unit, false);
                          },
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // _updateStock(product, unit, true);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
