import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pooja_cart/features/presentation/screens/admin/add_new_item/widgets/add_new_item_form.dart';

import '../../../common_widgets/nav_bar.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/head_container.dart';
import 'widgets/inventory_action_card.dart';
import 'widgets/low_stock_alert.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/sales_chart.dart';
import 'widgets/stock_table.dart';
import 'widgets/top_selling_items.dart';

// Utility class for responsive design
class ResponsiveUtils {
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 650 && width < 1100;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }

  static double responsiveFontSize(
    BuildContext context, {
    double mobile = 14,
    double desktop = 16,
  }) {
    if (isDesktop(context)) return desktop;
    return mobile;
  }

  static double get standardSpacing => 16.0;

  static double responsiveIconSize(BuildContext context) {
    return isDesktop(context) ? 24.0 : 20.0;
  }

  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  static Widget responsiveLayout({
    required BuildContext context,
    required Widget mobileLayout,
    Widget? tabletLayout,
    required Widget desktopLayout,
  }) {
    if (isDesktop(context)) return desktopLayout;
    if (isTablet(context) && tabletLayout != null) return tabletLayout;
    return mobileLayout;
  }
}

class WebNavBar extends StatelessWidget {
  final String currentRoute;
  final Function(String) onItemSelected;

  const WebNavBar({
    super.key,
    required this.currentRoute,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppTitle(),
        const SizedBox(width: 16),
        Spacer(),
        const SizedBox(width: 32),
        _buildNavItem(context, 'Dashboard', '/dashboard', Icons.dashboard),
        _buildNavItem(context, 'Inventory', '/inventory', Icons.inventory),
        _buildNavItem(context, 'Orders', '/orders', Icons.shopping_cart),
        _buildNavItem(context, 'Customers', '/customers', Icons.people),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    final isSelected = currentRoute == route;

    return InkWell(
      onTap: () => onItemSelected(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTimeRange _dateRange;

  // Mock data
  late DashboardData dashboardData;
  late InventoryData inventoryData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _dateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );

    // Initialize mock data
    dashboardData = DashboardData.sample();
    inventoryData = InventoryData.sample();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildResponsiveLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCartScreen(),
        tooltip: 'Create New Order',
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDesktopOrWeb = ResponsiveUtils.isDesktop(context);

    return AppBar(
      toolbarHeight: ResponsiveUtils.responsiveValue(
        context,
        mobile: 70.0,
        desktop: 80.0,
      ),
      title:
          isDesktopOrWeb
              ? WebNavBar(currentRoute: '/dashboard', onItemSelected: (item) {})
              : const Text(
                'Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      actions: [
        IconButton(
          icon: Icon(
            Icons.calendar_today,
            size: ResponsiveUtils.responsiveIconSize(context),
          ),
          onPressed: () => _selectDateRange(context),
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: ResponsiveUtils.responsiveIconSize(context),
          ),
          onPressed: () => _refreshDashboardData(),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildResponsiveLayout() {
    return ResponsiveUtils.responsiveLayout(
      context: context,
      mobileLayout: _buildMobileLayout(),
      tabletLayout: _buildTabletLayout(),
      desktopLayout: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.standardSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            SizedBox(height: ResponsiveUtils.standardSpacing),
            _buildMobileTabs(),
            SizedBox(height: ResponsiveUtils.standardSpacing),
            _buildInventoryActionCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sales'),
            Tab(text: 'Stock'),
            Tab(text: 'Orders'),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: 500, // Fixed height for mobile tab content
          child: TabBarView(
            controller: _tabController,
            children: [_buildSalesTab(), _buildStockTab(), _buildOrdersTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.standardSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            SizedBox(height: ResponsiveUtils.standardSpacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildSalesTab()),
                SizedBox(width: ResponsiveUtils.standardSpacing),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildTopSellingItems(),
                      SizedBox(height: ResponsiveUtils.standardSpacing),
                      _buildLowStockItems(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.standardSpacing),
            _buildStockTab(),
            SizedBox(height: ResponsiveUtils.standardSpacing),
            _buildOrdersTab(),
            SizedBox(height: ResponsiveUtils.standardSpacing),
            _buildInventoryActionCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left sidebar for inventory actions
        Container(
          width: 250,
          height: double.infinity,
          padding: EdgeInsets.all(ResponsiveUtils.standardSpacing),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
          ),
          child: _buildInventorySidebar(),
        ),

        // Main content area
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.standardSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(),
                SizedBox(height: ResponsiveUtils.standardSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sales chart
                    Expanded(flex: 2, child: _buildSalesTab()),
                    SizedBox(width: ResponsiveUtils.standardSpacing),
                    // Side panel with top selling and low stock
                    Expanded(child: _buildTopSellingItems()),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.standardSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildStockTab()),
                    SizedBox(width: ResponsiveUtils.standardSpacing),
                    Expanded(child: _buildOrdersTab()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventorySidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildInventoryAction(
          title: 'Add New Item',
          icon: Icons.add_box,
          color: Colors.blue,
          onTap: () => _navigateToAddItemScreen(context),
        ),
        const SizedBox(height: 16),
        _buildInventoryAction(
          title: 'Scan Items',
          icon: Icons.qr_code_scanner,
          color: Colors.purple,
          onTap: () => _navigateToScanScreen(),
        ),
        const SizedBox(height: 16),
        _buildInventoryAction(
          title: 'Generate Reports',
          icon: Icons.bar_chart,
          color: Colors.green,
          onTap: () => _generateReports(),
        ),
        const SizedBox(height: 16),
        _buildInventoryAction(
          title: 'Export Data',
          icon: Icons.cloud_download,
          color: Colors.orange,
          onTap: () => _exportData(),
        ),
        const Divider(height: 40),
        const Text(
          'Low Stock Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LowStockAlert(
            items: inventoryData.lowStockItems,
            onRestock: (id) => _navigateToRestockScreen(id),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryAction({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: ResponsiveUtils.responsiveValue(
        context,
        mobile: 1,
        tablet: 2,
        desktop: 4,
      ),
      childAspectRatio: ResponsiveUtils.responsiveValue(
        context,
        mobile: 3,
        tablet: 2.2,
        desktop: 1.7,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: ResponsiveUtils.standardSpacing,
      mainAxisSpacing: ResponsiveUtils.standardSpacing,
      children: [
        DashboardCard(
          title: 'Today\'s Sales',
          value: '₹${dashboardData.todaySales.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
          change: dashboardData.salesChangePercentage,
        ),
        DashboardCard(
          title: 'Total Stock Value',
          value: '₹${dashboardData.totalStockValue.toStringAsFixed(2)}',
          icon: Icons.inventory_2,
          color: Colors.blue,
          change: dashboardData.stockValueChangePercentage,
        ),
        DashboardCard(
          title: 'New Stock Items',
          value: '${dashboardData.newStockItems}',
          icon: Icons.new_releases,
          color: Colors.purple,
        ),
        DashboardCard(
          title: 'Low Stock Items',
          value: '${dashboardData.lowStockItems}',
          icon: Icons.warning_amber,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSalesTab() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          HeadContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sales Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${DateFormat('dd MMM').format(_dateRange.start)} - ${DateFormat('dd MMM').format(_dateRange.end)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SalesChart(salesData: dashboardData.salesData),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          HeadContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, size: 20),
                  onPressed: () => _showFilterDialog(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: StockTable(stockItems: inventoryData.stockItems),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          HeadContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Orders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _navigateToOrdersScreen(),
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: OrderSummaryCard(
              orders: dashboardData.recentOrders,
              onViewOrderDetails: (id) => _navigateToOrderDetails(id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingItems() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          HeadContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Selling Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () => _showItemsOptions('top'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: TopSellingItems(items: dashboardData.topSellingItems),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockItems() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          HeadContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Low Stock Alert',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () => _showItemsOptions('low'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: LowStockAlert(
              items: inventoryData.lowStockItems,
              onRestock: (id) => _navigateToRestockScreen(id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryActionCards() {
    return GridView.count(
      crossAxisCount: ResponsiveUtils.responsiveValue(
        context,
        mobile: 2,
        tablet: 4,
        desktop: 4,
      ),
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: ResponsiveUtils.standardSpacing,
      mainAxisSpacing: ResponsiveUtils.standardSpacing,
      children: [
        InventoryActionCard(
          title: 'Add New Item',
          icon: Icons.add_box,
          color: Colors.blue,
          onTap: () => _navigateToAddItemScreen(context),
        ),
        InventoryActionCard(
          title: 'Scan Items',
          icon: Icons.qr_code_scanner,
          color: Colors.purple,
          onTap: () => _navigateToScanScreen(),
        ),
        InventoryActionCard(
          title: 'Generate Reports',
          icon: Icons.bar_chart,
          color: Colors.green,
          onTap: () => _generateReports(),
        ),
        InventoryActionCard(
          title: 'Export Data',
          icon: Icons.cloud_download,
          color: Colors.orange,
          onTap: () => _exportData(),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
        // In a real app, we would fetch new data for the selected range
        _refreshDashboardData();
      });
    }
  }

  void _refreshDashboardData() {
    // In a real app, this would fetch fresh data from an API
    setState(() {
      dashboardData = DashboardData.sample();
      inventoryData = InventoryData.sample();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Stock Items'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Category'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      ['All', 'Category A', 'Category B', 'Category C'].map((
                        category,
                      ) {
                        return FilterChip(
                          label: Text(category),
                          selected: category == 'All',
                          onSelected: (selected) {
                            // Apply filter
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Sort By'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      ['Name', 'Stock', 'Price', 'Value'].map((sortOption) {
                        return ChoiceChip(
                          label: Text(sortOption),
                          selected: sortOption == 'Name',
                          onSelected: (selected) {
                            // Apply sorting
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply'),
              ),
            ],
          ),
    );
  }

  void _showItemsOptions(String type) {
    final List<String> options = [
      'Export to CSV',
      'Print Report',
      type == 'low' ? 'Restock All' : 'View Details',
    ];

    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  Navigator.pop(context);
                  // Handle option selection
                },
              );
            },
          ),
    );
  }

  // Navigation functions
  void _navigateToAddItemScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => AddNewItemForm(),
    );
    // context.go('/admin/add_product');
  }

  void _navigateToScanScreen() {
    // Navigate to scan screen
  }

  void _generateReports() {
    // Generate reports
  }

  void _exportData() {
    // Export data
  }

  void _navigateToRestockScreen(int id) {
    // Navigate to restock screen with the specified item ID
  }

  void _navigateToOrdersScreen() {
    // Navigate to orders screen
  }

  void _navigateToOrderDetails(String id) {
    // Navigate to order details screen with the specified order ID
  }

  void _navigateToCartScreen() {
    // Navigate to cart screen to create a new order
  }
}
