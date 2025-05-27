import 'package:flutter/material.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

class MetricsSection extends StatelessWidget {
  final Metrics metrics;
  const MetricsSection({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 500
                ? 2
                : 1;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: 2.5,
          children: [
            _buildMetricCard(
              context: context,
              title: 'Today Orders',
              value: metrics.todayOrders.toString(),
              icon: Icons.shopping_cart,
            ),
            _buildMetricCard(
              context: context,
              title: 'Total Orders',
              value: metrics.totalOrders.toString(),
              icon: Icons.assignment,
            ),
            _buildMetricCard(
              context: context,
              title: 'Today Revenue',
              value: metrics.todayRevenue.toString(),
              icon: Icons.currency_rupee,
            ),
            _buildMetricCard(
              context: context,
              title: 'Total Revenue',
              value: metrics.totalRevenue.toString(),
              icon: Icons.currency_rupee_rounded,
            ),
          ],
        );
      },
    );
  }
}

Widget _buildMetricCard({
  required BuildContext context,
  required String title,
  required String value,
  required IconData icon,
}) {
  return Card(
    color: Theme.of(context).colorScheme.surface,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    ),
  );
}
