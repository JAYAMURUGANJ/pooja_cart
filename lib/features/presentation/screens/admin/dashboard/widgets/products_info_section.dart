import 'package:flutter/material.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

class ProductsInfoSection extends StatelessWidget {
  final Products? products;
  const ProductsInfoSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Products",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(onPressed: () {}, child: const Text("View All")),
          ],
        ),
        _buildProductsInfoCardsSection(),
        _buildTopSellingProductsList(context),
        _buildLowStockProductsList(context),
      ],
    );
  }

  Widget _buildLowStockProductsList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Low Stock Products",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: products?.lowStock?.length ?? 0,
          separatorBuilder:
              (context, index) =>
                  const Divider(indent: 18, endIndent: 16, thickness: 0.5),
          itemBuilder: (context, index) {
            final product = products!.lowStock![index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text(product.productName.toString()),
              subtitle: Text("Product Id: ${product.productId}"),
              trailing: Text("In Stock: ${product.inStock}"),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopSellingProductsList(BuildContext context) {
    if (products?.topSelling == null || products!.topSelling!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Top Selling Products",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: products?.topSelling?.length ?? 0,
          separatorBuilder:
              (context, index) =>
                  const Divider(indent: 18, endIndent: 16, thickness: 0.5),
          itemBuilder: (context, index) {
            final product = products!.topSelling![index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text(product.productName.toString()),
              subtitle: Text("Price: ${product.productId}"),
              trailing: Text("Sold: ${product.totalSold}"),
            );
          },
        ),
      ],
    );
  }

  LayoutBuilder _buildProductsInfoCardsSection() {
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
          childAspectRatio: 2.8,
          children: [
            _buildProductInfoCard(
              context: context,
              title: 'Total Products',
              value: products!.totalProducts.toString(),
              icon: Icons.shopping_cart,
            ),
            _buildProductInfoCard(
              context: context,
              title: 'Active Products',
              value: products!.activeProducts.toString(),
              icon: Icons.shopping_cart,
            ),
            _buildProductInfoCard(
              context: context,
              title: 'InActive Products',
              value: products!.inactiveProducts.toString(),
              icon: Icons.assignment,
            ),
            _buildProductInfoCard(
              context: context,
              title: 'Out of Stock Products',
              value: products!.outOfStock.toString(),
              icon: Icons.currency_rupee_rounded,
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
}
