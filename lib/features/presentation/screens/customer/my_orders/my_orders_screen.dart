import 'package:flutter/material.dart';
import 'package:pooja_cart/features/presentation/screens/customer/my_orders/widgets/order_search_panel.dart';
import 'package:pooja_cart/features/presentation/screens/customer/my_orders/widgets/orders_display_widget.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Load all orders on init (optional)
    // _fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on width
          final isWideScreen = constraints.maxWidth > 900;

          if (isWideScreen) {
            // Desktop/Tablet layout (Side by side)
            return _buildWideScreenLayout();
          } else {
            // Mobile layout (Stacked)
            return _buildNarrowScreenLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search panel (30% width)
        Container(
          width: 320,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: OrderSearchPanel(),
        ),

        // Orders display (70% width)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(child: OrdersDisplayWidget()),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search panel
            OrderSearchPanel(),
            const SizedBox(height: 24.0),
            // Orders display
            OrdersDisplayWidget(),
          ],
        ),
      ),
    );
  }
}
