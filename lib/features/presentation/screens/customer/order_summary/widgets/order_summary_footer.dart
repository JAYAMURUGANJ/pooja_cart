import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/presentation/common_widgets/extensions.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../../../../domain/entities/order_items/order_items.dart';
import '../../home/cubit/order_items/order_items_cubit.dart';
import 'price_details_widget.dart';

Widget buildOrderSummaryFooter(BuildContext context, OrderItemsState state) {
  List<OrderItems> items = state.orderItems;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      PriceDetailsWidget(items: items),
      Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        width: double.infinity,
        height: 45,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.shopify_sharp, color: Colors.white),
          label: Text(
            "Checkout",
            style: TextStyle(
              fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            if (items.isNotEmpty) {
              context.go('/confirm_order', extra: items);
            } else {
              context.showSnackBar(message: "cart is empty");
            }
          },
        ),
      ),
    ],
  );
}
