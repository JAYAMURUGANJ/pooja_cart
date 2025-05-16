import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final List _navBarItems = [
    {'title': 'Add New Item', 'icon': Icons.add},
    {'title': 'Manage Items', 'icon': Icons.list},
    {'title': 'Orders', 'icon': Icons.shopping_cart},
    {'title': 'Settings', 'icon': Icons.settings},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      endDrawer:
          (context.isMobile || context.isTablet) ? _buildDrawer(context) : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'S.Plani Store Admin',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions:
            (context.isMobile || context.isTablet)
                ? [
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    icon: Icon(Icons.menu),
                  ),
                ]
                : [Row(children: [])],
      ),
      body: Center(
        child: Text(
          'Admin Dashboard',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.88,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'S.Plani Store Admin',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Add New Item'),
                    onTap: () {
                      Navigator.pushNamed(context, '/admin/add_new_item');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
