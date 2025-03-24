import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderData {
  final String id;
  final String customer;
  final double amount;
  final DateTime date;
  final String status;

  OrderData({
    required this.id,
    required this.customer,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class OrderSummaryCard extends StatelessWidget {
  final List<OrderData> orders;
  final Function(String) onViewOrderDetails;

  const OrderSummaryCard({
    super.key,
    required this.orders,
    required this.onViewOrderDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Text(
            order.id,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(order.customer),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(order.date),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${order.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      order.status == 'Completed'
                          ? Colors.green.shade100
                          : (order.status == 'Processing'
                              ? Colors.blue.shade100
                              : Colors.orange.shade100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        order.status == 'Completed'
                            ? Colors.green.shade800
                            : (order.status == 'Processing'
                                ? Colors.blue.shade800
                                : Colors.orange.shade800),
                  ),
                ),
              ),
            ],
          ),
          onTap: () => onViewOrderDetails(order.id),
        );
      },
    );
  }
}
