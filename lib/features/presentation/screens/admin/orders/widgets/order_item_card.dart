import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_orders/admin_orders_response.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import 'order_details_widget.dart' show OrderDetailsPage;

class OrderItemCard extends StatefulWidget {
  final OrdersList item;
  const OrderItemCard({super.key, required this.item});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    return _buildOrderCard(widget.item);
  }

  Widget _buildOrderCard(OrdersList item) {
    // Format the date
    final orderDate = DateTime.parse(item.orderDate.toString());
    final formattedDate = DateFormat(
      'MMM dd, yyyy • hh:mm a',
    ).format(orderDate);

    // Determine status color
    Color statusColor;
    switch (item.orderStatus!.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'processing':
        statusColor = Colors.blue;
        break;
      case 'shipped':
        statusColor = Colors.indigo;
        break;
      case 'delivered':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      case 'returned':
        statusColor = Colors.purple;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to order details
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrderDetailsPage(order: item),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Order ID: ORD${item.orderId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(
                      item.orderStatus!.isEmpty ? 'Pending' : item.orderStatus!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: statusColor,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.person_outline,
                          'Customer',
                          item.name!,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.phone_outlined,
                          'Phone',
                          item.mobileNo!,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today_outlined,
                          'Date',
                          formattedDate,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.payments_outlined,
                          'Payment',
                          item.paymentMethod!.isEmpty
                              ? 'Not specified'
                              : item.paymentMethod!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Flex(
                direction: context.isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subtotal: ₹${item.subTotal!.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Total: ₹${item.total!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),

                        onPressed: () {
                          // Edit order
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // View order details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OrderDetailsPage(order: item),
                            ),
                          );
                        },
                        child: const Text('Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
