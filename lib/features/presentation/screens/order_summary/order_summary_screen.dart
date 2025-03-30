import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../common_widgets/head_container.dart';
import '../home/cubit/order_items/order_items_cubit.dart';
import '../home/widgets/quantity_controller.dart';
import 'widgets/order_summary_footer.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentSidebarRatio = context.contentSidebarRatio;
    return Expanded(
      flex: contentSidebarRatio[1],
      child: BlocBuilder<OrderItemsCubit, OrderItemsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(200, 80),
              child: _orderSummaryHead(context),
            ),
            body:
                state.orderItems.isNotEmpty
                    ? _buildBody(state)
                    : const Center(child: Text("No items in cart")),
            bottomNavigationBar: buildOrderSummaryFooter(context, state),
          );
        },
      ),
    );
  }

  Widget _orderSummaryHead(BuildContext context) {
    return HeadContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: context.responsiveFontSize(mobile: 18, desktop: 22),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: context.responsiveIconSize,
              // color:
              //     (itemQuantities.isNotEmpty)
              //         ? Colors.red.shade400
              //         : Colors.grey.shade400,
            ),
            onPressed:
                // (itemQuantities.isNotEmpty)
                //     ? () {
                //       ProductUtils.showClearCartDialog(context, clearAllItems);
                //     }
                //     :
                null,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(OrderItemsState state) {
    return ListView.separated(
      itemCount: state.orderItems.length,
      separatorBuilder:
          (context, index) => const Divider(height: 20, thickness: 0.5),
      itemBuilder: (context, index) {
        final item = state.orderItems[index];
        return _buildOrderItem(item, context);
      },
    );
  }

  Padding _buildOrderItem(OrderItems item, BuildContext context) {
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
                item.name ?? "Unknown",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () {
                  context.read<OrderItemsCubit>().removeOrderItem(
                    item.productId!,
                    item.unitId!,
                  );
                },
                child: Icon(Icons.close, size: 18),
              ),
            ],
          ),
          Text(
            "₹${item.sellingPrice!.toStringAsFixed(2)} × ${item.quantity}",
            style: const TextStyle(color: Colors.grey),
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
          QuantityController(
            quantity: item.quantity!,
            onQuantityChanged: (newQuantity) {
              if (newQuantity <= 0) {
                BlocProvider.of<OrderItemsCubit>(
                  context,
                ).removeOrderItem(item.productId!, item.unitId!);
              } else {
                BlocProvider.of<OrderItemsCubit>(
                  context,
                ).updateQuantity(item.productId!, item.unitId!, newQuantity);

                // Update quantity logic if needed
              }
            },
            width: 120,
          ),
        ],
      ),
    );
  }
}
