import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/pooja_item_utils.dart';
import '../../../../domain/entities/order_items/order_items.dart';
import '../../../../domain/helpers/order_calculation_helper.dart';
import '../../home/cubit/order_items/order_items_cubit.dart';

Widget buildOrderSummaryFooter(BuildContext context, OrderItemsState state) {
  List<OrderItems> items = state.orderItems;
  final calculator = OrderCalculationHelper(items);
  int subtotal = calculator.subtotal;
  int discount = calculator.discount;
  int total = calculator.total;
  int discountPercentage = calculator.discountPercentage.toInt();

  return Container(
    padding: context.responsivePadding.copyWith(
      top: context.standardSpacing * 1.5,
      bottom: context.standardSpacing * 1.5,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          spreadRadius: 1,
          blurRadius: 6,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Column(
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
        SizedBox(
          width: double.infinity,
          height: context.controlHeight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopify_sharp, color: Colors.white),
            label: Text(
              "Confirm Order",
              style: TextStyle(
                fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              print(orderItemsListToJson(items));
              _shareOrderViaWhatsApp(context, items);
            },
          ),
        ),
      ],
    ),
  );
}

Future<void> _shareOrderViaWhatsApp(
  BuildContext context,
  List<OrderItems> items,
) async {
  if (items.isEmpty) {
    ProductUtils.showMessage(context, 'Your order is empty');
    return;
  }

  final String whatsappNumber = "9566632370";

  final String orderText = ProductUtils.generateOrderSummary(items);
  final String encodedMessage = Uri.encodeComponent(orderText);
  final String formattedNumber = whatsappNumber.replaceAll(
    RegExp(r'[^0-9]'),
    '',
  );

  final Uri whatsappUri = Uri.parse(
    'https://wa.me/$formattedNumber?text=$encodedMessage',
  );

  try {
    bool launched = await launchUrl(
      whatsappUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      if (context.mounted) {
        ProductUtils.showMessage(context, 'Could not launch WhatsApp.');
      }
    }
  } catch (e) {
    if (context.mounted) {
      ProductUtils.showMessage(context, 'Error opening WhatsApp: $e');
    }
  }
}
