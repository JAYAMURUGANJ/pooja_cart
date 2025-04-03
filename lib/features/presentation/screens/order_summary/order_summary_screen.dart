import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/features/presentation/common_widgets/alert_widgets.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../../../utils/pooja_item_utils.dart';
import '../../common_widgets/head_container.dart';
import '../home/cubit/order_items/order_items_cubit.dart';
import '../home/widgets/quantity_controller.dart';
import 'widgets/order_summary_footer.dart';

class OrderSummaryScreen extends StatelessWidget {
  final bool showHeader;
  const OrderSummaryScreen({super.key, this.showHeader = false});

  @override
  Widget build(BuildContext context) {
    final contentSidebarRatio = context.contentSidebarRatio;
    return Expanded(
      flex: contentSidebarRatio[1],
      child: BlocBuilder<OrderItemsCubit, OrderItemsState>(
        builder: (context, state) {
          List<OrderItems> cartItems = state.orderItems;
          return Scaffold(
            appBar:
                showHeader
                    ? PreferredSize(
                      preferredSize: Size(200, 80),
                      child: _buildHead(context, cartItems),
                    )
                    : null,
            body:
                state.orderItems.isNotEmpty
                    ? _buildBody(state)
                    : const Center(child: Text("No items in cart")),
            bottomNavigationBar: Visibility(
              visible: cartItems.isNotEmpty,
              child: buildOrderSummaryFooter(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHead(BuildContext context, List<OrderItems> cartItems) {
    return HeadContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Cart",
            style: TextStyle(
              fontSize: context.responsiveFontSize(mobile: 16, desktop: 18),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: context.responsiveIconSize,
              color: (cartItems.isNotEmpty) ? Colors.white : null,
            ),
            onPressed:
                (cartItems.isNotEmpty)
                    ? () {
                      ProductUtils.showClearCartDialog(context, () {
                        BlocProvider.of<OrderItemsCubit>(
                          context,
                        ).clearAllItems();
                      });
                    }
                    : null,
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
                  AlertWidgets(context).showCommonAlertDialog(
                    title: "Confirm remove ?",
                    content: "Are you sure want to remove this item",
                    actionBtnTxt: "Remove",
                    action: () {
                      context.read<OrderItemsCubit>().removeOrderItem(
                        item.productId!,
                        item.unitId!,
                      );
                    },
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
                AlertWidgets(context).showCommonAlertDialog(
                  content: "Are you sure want to remove from cart?",
                  actionBtnTxt: "Remove",
                  action: () {
                    BlocProvider.of<OrderItemsCubit>(
                      context,
                    ).removeOrderItem(item.productId!, item.unitId!);
                  },
                );
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
