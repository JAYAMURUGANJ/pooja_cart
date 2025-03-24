// Widget for section headers
import 'package:flutter/material.dart';

import 'low_stock_alert.dart';
import 'order_summary_card.dart';
import 'sales_chart.dart';
import 'stock_table.dart';
import 'top_selling_items.dart';

class HeadContainer extends StatelessWidget {
  final Widget child;

  const HeadContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

// Mock data models
class DashboardData {
  final double todaySales;
  final double totalStockValue;
  final int newStockItems;
  final int lowStockItems;
  final double salesChangePercentage;
  final double stockValueChangePercentage;
  final List<SalesData> salesData;
  final List<OrderData> recentOrders;
  final List<TopSellingItem> topSellingItems;

  DashboardData({
    required this.todaySales,
    required this.totalStockValue,
    required this.newStockItems,
    required this.lowStockItems,
    required this.salesChangePercentage,
    required this.stockValueChangePercentage,
    required this.salesData,
    required this.recentOrders,
    required this.topSellingItems,
  });

  // Sample data factory
  factory DashboardData.sample() {
    return DashboardData(
      todaySales: 25680.50,
      totalStockValue: 356789.75,
      newStockItems: 12,
      lowStockItems: 8,
      salesChangePercentage: 5.2,
      stockValueChangePercentage: 2.8,
      salesData: List.generate(
        7,
        (index) => SalesData(
          date: DateTime.now().subtract(Duration(days: 6 - index)),
          amount: 20000 + (index * 1500) + (index % 2 == 0 ? 2000 : -1000),
        ),
      ),
      recentOrders: List.generate(
        5,
        (index) => OrderData(
          id: 'ORD-2023${10000 + index}',
          customer: 'Customer ${index + 1}',
          amount: 1500.0 + (index * 500),
          date: DateTime.now().subtract(Duration(hours: index * 4)),
          status:
              index % 3 == 0
                  ? 'Completed'
                  : (index % 3 == 1 ? 'Processing' : 'Delivered'),
        ),
      ),
      topSellingItems: List.generate(
        5,
        (index) => TopSellingItem(
          name: 'Product ${index + 1}',
          sold: 100 - (index * 15),
          revenue: 15000.0 - (index * 2500),
        ),
      ),
    );
  }
}

class InventoryData {
  final List<StockItem> stockItems;
  final List<LowStockItem> lowStockItems;

  InventoryData({required this.stockItems, required this.lowStockItems});

  // Sample data factory
  factory InventoryData.sample() {
    return InventoryData(
      stockItems: List.generate(
        10,
        (index) => StockItem(
          id: index + 1,
          name: 'Product ${index + 1}',
          category:
              index % 3 == 0
                  ? 'Category A'
                  : (index % 3 == 1 ? 'Category B' : 'Category C'),
          stock: index * 10 + 5,
          price: 100.0 + (index * 25),
          value: (100.0 + (index * 25)) * (index * 10 + 5),
        ),
      ),
      lowStockItems: List.generate(
        5,
        (index) => LowStockItem(
          id: index + 1,
          name: 'Low Stock Item ${index + 1}',
          currentStock: index + 2,
          reorderLevel: 10,
        ),
      ),
    );
  }
}
