import 'package:flutter/material.dart';

class StockItem {
  final int id;
  final String name;
  final String category;
  final int stock;
  final double price;
  final double value;

  StockItem({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    required this.value,
  });
}

class StockTable extends StatelessWidget {
  final List<StockItem> stockItems;

  const StockTable({super.key, required this.stockItems});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Value')),
        ],
        rows:
            stockItems
                .map(
                  (item) => DataRow(
                    cells: [
                      DataCell(Text(item.name)),
                      DataCell(Text(item.category)),
                      DataCell(Text('${item.stock}')),
                      DataCell(Text('₹${item.price.toStringAsFixed(2)}')),
                      DataCell(Text('₹${item.value.toStringAsFixed(2)}')),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
