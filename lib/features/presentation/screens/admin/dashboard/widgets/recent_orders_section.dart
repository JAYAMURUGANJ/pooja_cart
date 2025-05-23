import 'package:flutter/material.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

class RecentOrdersSection extends StatelessWidget {
  final List<RecentOrder>? recentOrders;
  const RecentOrdersSection({super.key, required this.recentOrders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Orders",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(onPressed: () {}, child: const Text("View All")),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders?.length ?? 0,
            separatorBuilder:
                (context, index) =>
                    const Divider(indent: 18, endIndent: 16, thickness: 0.5),
            itemBuilder: (context, index) {
              final order = recentOrders![index];
              return ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                visualDensity: VisualDensity.compact,
                leading: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),

                title: Text(
                  "ORD-${order.orderId}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Delivery Address: ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: order.customerName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: " (${order.mobileNo})",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: "\n${order.orderDate}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: "\nTotal Amount: ${order.orderTotal}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                trailing: Text(
                  (order.orderStatus == null || order.orderStatus!.isEmpty)
                      ? "Pending"
                      : order.orderStatus.toString(),
                  style: TextStyle(
                    color:
                        order.orderStatus == 'Completed'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
