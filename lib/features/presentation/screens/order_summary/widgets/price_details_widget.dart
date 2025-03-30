import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../../../domain/entities/order_items/order_items.dart';
import '../../../../domain/helpers/order_calculation_helper.dart';

class PriceDetailsWidget extends StatelessWidget {
  const PriceDetailsWidget({super.key, required this.items});

  final List<OrderItems> items;

  @override
  Widget build(BuildContext context) {
    final calculator = OrderCalculationHelper(items);
    int subtotal = calculator.subtotal;
    int discount = calculator.discount;
    int total = calculator.total;
    int discountPercentage = calculator.discountPercentage.toInt();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // MRP total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Subtotal (MRP)",
              style: TextStyle(
                fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              "₹${subtotal.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: context.standardSpacing / 2),
        // If discount available
        if (discount > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount($discountPercentage%)",
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "-₹${discount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        Divider(color: Colors.grey.shade300, thickness: 1),
        SizedBox(height: context.standardSpacing / 2),
        // Total amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "₹${total.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: context.standardSpacing),

        // Share WhatsApp button
      ],
    );
  }
}
