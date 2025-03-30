import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../home/cubit/order_items/order_items_cubit.dart';
import '../../home/widgets/quantity_controller.dart';

class ConfirmOrderItems extends StatefulWidget {
  final List<OrderItems> orderItems;
  const ConfirmOrderItems({super.key, required this.orderItems});

  @override
  State<ConfirmOrderItems> createState() => _ConfirmOrderItemsState();
}

class _ConfirmOrderItemsState extends State<ConfirmOrderItems> {
  bool showAll = false;
  List<OrderItems> get orderItems => widget.orderItems;
  @override
  Widget build(BuildContext context) {
    int itemCount = orderItems.length;
    int itemsToShow = showAll ? itemCount : (itemCount > 2 ? 2 : itemCount);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Order Items",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.left,
          ),
          if (orderItems.isNotEmpty) ...[
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent scrolling inside ListView
                itemBuilder: (context, index) {
                  return _buildOrderItem(index);
                },
                separatorBuilder:
                    (context, index) => const Divider(thickness: 0.5),
                itemCount: itemsToShow,
              ),
            ),
            if (widget.orderItems.length >
                2) // Show button only if there are more than 2 items
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(showAll ? "View Less" : "View All"),
                ),
              ),
          ] else
            Center(child: Text("No items added")),
        ],
      ),
    );
  }

  Widget _buildOrderItem(int index) {
    OrderItems item = orderItems[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderItems[index].name ?? "Unknown",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            "₹${item.mrp!.toStringAsFixed(2)}",
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey.shade500,
              fontSize: context.responsiveFontSize(mobile: 12, desktop: 13),
            ),
          ),
          Text(
            "₹${item.sellingPrice!.toStringAsFixed(2)} × ${item.quantity}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "You Save ₹${((item.mrp! - item.sellingPrice!) * item.quantity!).toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "₹${(item.sellingPrice! * item.quantity!).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return ListTile(
      title: Text(widget.orderItems[index].name!),
      subtitle: Text(widget.orderItems[index].quantity!.toString()),
    );
  }
}
