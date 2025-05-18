import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/home_screen.dart';
import 'package:pooja_cart/features/presentation/screens/customer/my_orders/my_orders_screen.dart';
import 'package:pooja_cart/features/presentation/screens/customer/order_summary/order_summary_screen.dart';
import 'package:pooja_cart/features/presentation/screens/customer/profile/profile_screen.dart';

import 'features/presentation/common_widgets/app_scaffold.dart';
import 'features/presentation/screens/admin/add_new_item/add_new_item_screen.dart';
import 'features/presentation/screens/admin/main_page/admin_main_page.dart';
import 'features/presentation/screens/admin/main_page/dashboard_screen.dart';
import 'features/presentation/screens/customer/confirm_order/confirm_order_screen.dart';
import 'features/presentation/screens/customer/contact/contact_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/admin',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder:
              (context, state) => NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const ContactPage()),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const OrderSummaryScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const ProfileScreen()),
        ),
        GoRoute(
          path: '/my_orders',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const MyOrdersScreen()),
        ),
        GoRoute(
          path: '/confirm_order',
          pageBuilder: (context, state) {
            final orderItems = state.extra as List<OrderItems>? ?? [];
            return NoTransitionPage(
              child: ConfirmOrderScreen(orderItems: orderItems),
            );
          },
        ),
        GoRoute(
          path: '/admin',
          pageBuilder:
              (context, state) => NoTransitionPage(
                child: AdminMainPage() /* const DashboardScreen() */,
              ),
          routes: [
            GoRoute(
              path: '/add_product',
              pageBuilder:
                  (context, state) =>
                      NoTransitionPage(child: AddNewItemScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
