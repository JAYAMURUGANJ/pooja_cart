import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../cart/cubit/order_items/order_items_cubit.dart';
import '../cart/widgets/quantity_controller.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentSidebarRatio = context.contentSidebarRatio;
    return BlocBuilder<OrderItemsCubit, OrderItemsState>(
      builder: (context, state) {
        if (state.orderItems.isEmpty) {
          return Text("No items in cart");
        }
        return Expanded(
          flex: contentSidebarRatio[1],
          child: _buildBody(state),
        );
      },
    );
  }

  ListView _buildBody(OrderItemsState state) {
    return ListView.builder(
          itemCount: state.orderItems.length,
          itemBuilder: (context, index) {
            final item = state.orderItems[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              title: Text(
                item.name ?? "Unknown",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${55 /* item.sellingPrice!.toStringAsFixed(2) */} × ${item.quantity}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if ( /* discountTotal */ 10 >
                      0) // Show discount only if applicable
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "You Save ₹${ /* discountTotal.toStringAsFixed(2) */ 15}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<OrderItemsCubit>().removeOrderItem(
                        item.id!,
                        item.unitId!,
                      );
                    },
                  ),
                  Text(
                    "₹${(10 * item.quantity!).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  QuantityController(
                    quantity: item.quantity!,
                    onQuantityChanged: (newQuantity) {
                      if (newQuantity <= 0) {
                        BlocProvider.of<OrderItemsCubit>(
                          context,
                        ).removeOrderItem(item.id!, item.unitId!);
                      } else {
                        BlocProvider.of<OrderItemsCubit>(
                          context,
                        ).updateQuantity(item.id!, item.unitId!, newQuantity);

                        // Update quantity logic if needed
                      }
                    },
                    width: 120,
                  ),
                ],
              ),
            );
          },
        );
  }
}
