import 'package:flutter/material.dart';

import '../../../../../common/helpers/order_calculation_helper.dart';
import '../../../../../domain/entities/order_items/order_items.dart';

class MobileCartFooter extends StatelessWidget {
  const MobileCartFooter({
    super.key,
    required this.context,
    required this.orderItems,
    required this.onViewCart,
  });

  final BuildContext context;
  final List<OrderItems> orderItems;
  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    List<OrderItems> items = orderItems;
    int itemsCount = items.length;
    final calculator = OrderCalculationHelper(items);
    double total = calculator.total;
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      height: 60,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$itemsCount ${itemsCount == 1 ? 'item' : 'items'}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onViewCart,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "VIEW CART",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
