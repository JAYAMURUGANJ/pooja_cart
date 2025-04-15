import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../../../../common/helpers/order_calculation_helper.dart';
import '../../../../../domain/entities/order_items/order_items.dart';

class PriceDetailsWidget extends StatelessWidget {
  final List<OrderItems> items;

  const PriceDetailsWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final calculator = OrderCalculationHelper(items);
    final subtotal = calculator.subtotal;
    final discount = calculator.discount;
    final total = calculator.total;
    final discountPercentage = calculator.discountPercentage.toInt();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final responsiveSize = context.responsiveFontSize(mobile: 14, desktop: 14);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        spacing: 6,
        children: [
          _buildPriceRow(
            context,
            "Subtotal (MRP)",
            "₹${subtotal.toStringAsFixed(2)}",
            labelStyle: textTheme.bodyMedium?.copyWith(
              fontSize: responsiveSize,
              color: Colors.grey.shade700,
            ),
            valueStyle: textTheme.bodyMedium?.copyWith(
              fontSize: responsiveSize,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (discount > 0) ...[
            _buildPriceRow(
              context,
              "Discount ($discountPercentage%)",
              "-₹${discount.toStringAsFixed(2)}",
              labelStyle: textTheme.bodyMedium?.copyWith(
                fontSize: responsiveSize,
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
              valueStyle: textTheme.bodyMedium?.copyWith(
                fontSize: responsiveSize,
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: DottedLine(dashColor: Colors.grey.shade300),
          ),

          _buildPriceRow(
            context,
            "Total Amount",
            "₹${total.toStringAsFixed(2)}",
            labelStyle: textTheme.titleMedium?.copyWith(
              fontSize: context.responsiveFontSize(mobile: 16, desktop: 18),
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            valueStyle: textTheme.titleMedium?.copyWith(
              fontSize: context.responsiveFontSize(mobile: 16, desktop: 18),
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
