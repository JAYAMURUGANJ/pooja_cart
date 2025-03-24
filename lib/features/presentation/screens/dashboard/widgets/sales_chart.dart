// Charts and Tables components
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesData {
  final DateTime date;
  final double amount;

  SalesData({required this.date, required this.amount});
}

class SalesChart extends StatelessWidget {
  final List<SalesData> salesData;

  const SalesChart({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sales Trend',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Simplified chart representation
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        salesData.map((data) {
                          // Normalize height between 0.1 and 1.0
                          final maxAmount = salesData
                              .map((e) => e.amount)
                              .reduce((a, b) => a > b ? a : b);
                          final minAmount = salesData
                              .map((e) => e.amount)
                              .reduce((a, b) => a < b ? a : b);
                          final range = maxAmount - minAmount;
                          final normalizedHeight =
                              0.1 + ((data.amount - minAmount) / range) * 0.9;

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: normalizedHeight * 200,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('E').format(data.date),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total: ₹${salesData.map((e) => e.amount).reduce((a, b) => a + b).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
