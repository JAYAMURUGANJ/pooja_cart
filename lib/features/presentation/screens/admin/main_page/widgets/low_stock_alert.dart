import 'package:flutter/material.dart';

class LowStockItem {
  final int id;
  final String name;
  final int currentStock;
  final int reorderLevel;

  LowStockItem({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.reorderLevel,
  });
}

class LowStockAlert extends StatelessWidget {
  final List<LowStockItem> items;
  final Function(int) onRestock;

  const LowStockAlert({
    super.key,
    required this.items,
    required this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final percentage = item.currentStock / item.reorderLevel;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onRestock(item.id),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(60, 30),
                    ),
                    child: const Text('Restock'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                color:
                    percentage < 0.3
                        ? Colors.red
                        : (percentage < 0.7 ? Colors.orange : Colors.green),
              ),
              const SizedBox(height: 6),
              Text(
                'Current Stock: ${item.currentStock} / Reorder Level: ${item.reorderLevel}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }
}
