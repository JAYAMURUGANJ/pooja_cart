import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/admin/dashboard/dashboard_screen.dart';
import 'package:pooja_cart/features/presentation/screens/admin/main_page/cubit/page_navigation/page_navigation_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/admin/master/master_page.dart';
import 'package:pooja_cart/features/presentation/screens/admin/orders/order_page.dart';
import 'package:pooja_cart/features/presentation/screens/admin/report/report_screen.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../../common_widgets/nav_bar.dart';
import '../../../models/nav_bar_item_model.dart';
import '../products/admin_products_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<NavBarItemModel> navBarItems = [
    NavBarItemModel(label: 'Dashboard', icon: Icons.dashboard_rounded),
    NavBarItemModel(label: 'Orders', icon: Icons.checklist_outlined),
    NavBarItemModel(label: 'Products', icon: Icons.list),
    NavBarItemModel(label: 'Master', icon: Icons.settings_applications),
    NavBarItemModel(label: 'Report', icon: Icons.bar_chart_outlined),
  ];

  final List<Widget> _pages = [
    DashboardScreen(),
    OrdersPage(),
    AdminProductPage(),
    MasterPage(),
    ReportScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageNavigationCubit, int>(
      builder: (context, currentPage) {
        return Scaffold(
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          drawer:
              (context.isMobile || context.isTablet)
                  ? _buildDrawer(context)
                  : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.surface,
            excludeHeaderSemantics: true,
            title: AppTitle(),
            actions:
                (context.isMobile)
                    ? [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Icon(Icons.menu),
                      ),
                    ]
                    : [],
          ),
          body: Row(
            children: [
              if (!(context.isMobile)) _buildWebNavigation(currentPage),
              Expanded(child: _pages[currentPage]),
            ],
          ),
        );
      },
    );
  }

  NavigationRail _buildWebNavigation(int currentPage) {
    return NavigationRail(
      onDestinationSelected: (value) {
        BlocProvider.of<PageNavigationCubit>(context).changePage(value);
      },

      extended: context.isTablet ? false : true,
      useIndicator: true,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // selectedIconTheme: const IconThemeData(color: Colors.white),
      // unselectedIconTheme: const IconThemeData(color: Colors.grey),
      // selectedLabelTextStyle: const TextStyle(color: Colors.white),
      // unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
      destinations:
          navBarItems
              .map(
                (navItem) => NavigationRailDestination(
                  icon: Icon(navItem.icon),
                  label: Text(navItem.label),
                ),
              )
              .toList(),

      // List.generate(
      //   _navBarItems.length,
      //   (navItem) => NavigationRailDestination(
      //     icon: Icon(Icons.home),
      //     label: Text("Home"),
      //   ),
      // ),
      selectedIndex: currentPage,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
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
              children:
                  navBarItems
                      .map(
                        (navItem) => ListTile(
                          title: Text(navItem.label),
                          onTap: () {
                            _scaffoldKey.currentState?.closeDrawer();
                            BlocProvider.of<PageNavigationCubit>(
                              context,
                            ).changePage(navBarItems.indexOf(navItem));
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
