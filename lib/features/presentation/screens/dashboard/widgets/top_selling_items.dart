import 'package:flutter/material.dart';

class TopSellingItem {
  final String name;
  final int sold;
  final double revenue;

  TopSellingItem({
    required this.name,
    required this.sold,
    required this.revenue,
  });
}

class TopSellingItems extends StatelessWidget {
  final List<TopSellingItem> items;

  const TopSellingItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        // Calculate percentage for progress indicator
        final maxSold = items
            .map((e) => e.sold)
            .reduce((a, b) => a > b ? a : b);
        final percentage = item.sold / maxSold;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${item.sold} units',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade200,
                color: Colors.blue,
              ),
              const SizedBox(height: 6),
              Text(
                'Revenue: ₹${item.revenue.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }
}
